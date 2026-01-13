// ignore_for_file: public_member_api_docs

import 'package:mongo_dart/mongo_dart.dart';
import 'package:notes/Enum/collections_enum.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Model/login_model.dart';
import 'package:notes/Model/register.dart';
import 'package:notes/Model/update_user_model.dart';
import 'package:notes/utils/encryption_helper.dart';
import 'package:notes/utils/tokens.dart';

class UserRepository {
  UserRepository(this.db) {
    _collection = db.collection(CollectionsEnum.user.valueKey);
  }

  final Db db;
  late final DbCollection _collection;

  Future<Map<String, dynamic>?> isUserExists(String email) async {
    try {
      return await _collection.findOne(
        where.eq(KeysEnum.email.valueKey, email).fields([
          KeysEnum.password.valueKey,
          KeysEnum.id.valueKey,
        ]),
      );
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(LoginModel model) async {
    final user = await isUserExists(model.email);
    if (user == null) return null;

    if (!_isPasswordValid(user, model.password)) return null;

    final userId = _extractUserId(user);
    final newToken = TokensClass.generateToken(userId);

    return {
      KeysEnum.token.valueKey: newToken,
    };
  }

  Future<bool> logout(String token) async {
    try {
      return TokensClass.revokeToken(token);
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> register(RegisterModel model) async {
    try {
      final existingUser = await isUserExists(model.email!);
      if (existingUser != null) {
        return {
          'success': false,
          KeysEnum.message.valueKey: 'Email already exists',
        };
      }

      final hashedPassword = EncryptionHelper.encryptPassword(model.password!);
      final newModel = model.copyWith(password: hashedPassword);
      final result = await _collection.insertOne(newModel.toMap());
      
      return {
        'success': result.isSuccess,
         KeysEnum.message.valueKey: result.isSuccess
            ? 'Registration successful'
            : 'Registration failed',
      };
    } catch (e) {
      return {
        'success': false,
        KeysEnum.message.valueKey: 'An error occurred during registration',
      };
    }
  }

  Future<Map<String, dynamic>?> getUserData(String id) async {
    try {
      final objectId = _convertToObjectId(id);
      final result = await _collection.findOne(
        where.eq(KeysEnum.id.valueKey, objectId),
      );

      return _normalizeUserData(result);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateAccount(
    String id,
    UpdateUserModel model,
  ) async {
    try {
      final objectId = _convertToObjectId(id);

      final result = await _collection.updateOne(
        where.eq(KeysEnum.id.valueKey, objectId),
        {r'$set': model.toMap()},
      );

      if (result.isFailure) {
        return {
        'success': false,
        KeysEnum.message.valueKey: 'An error occurred during updated',
        };
      }

      return {
        'success': true,
        KeysEnum.message.valueKey: 'success updated',
      } ;
    } catch (e) {
      return {
        'success': false,
        KeysEnum.message.valueKey: e.toString(),
      } ;
    }
  }

  Future<bool> updatePassword(
    String id,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final objectId = _convertToObjectId(id);

      final currentPassword = await _getCurrentPassword(objectId);
      if (currentPassword == null) return false;

      if (!_verifyOldPassword(currentPassword, oldPassword)) return false;

      return await _updatePasswordInDb(objectId, newPassword);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAccount(String id) async {
    try {
      final objectId = _convertToObjectId(id);
      final result = await _collection.deleteOne(
        where.eq(KeysEnum.id.valueKey, objectId),
      );
      return result.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearAllUsers() async {
    try {
      final result = await _collection.deleteMany(where);
      return result.success;
    } catch (e) {
      return false;
    }
  }

  bool _isPasswordValid(Map<String, dynamic> user, String password) {
    final encryptedPassword = user[KeysEnum.password.valueKey]?.toString();
    if (encryptedPassword == null) return false;

    final decryptedPassword =
        EncryptionHelper.decryptPassword(encryptedPassword);
    return decryptedPassword == password;
  }

  String _extractUserId(Map<String, dynamic> user) {
    return (user[KeysEnum.id.valueKey] as ObjectId).oid;
  }

  ObjectId _convertToObjectId(String id) {
    return ObjectId.fromHexString(id);
  }

  Map<String, dynamic>? _normalizeUserData(Map<String, dynamic>? data) {
    if (data == null) return null;

    data[KeysEnum.id.valueKey] = (data[KeysEnum.id.valueKey] as ObjectId).oid;
    return data;
  }

//  bool _isUpdateSuccessful(Map<String, dynamic> result) {
//     return (result.containsKey('nModified') &&
//             ((result['nModified'] as int?) ?? 0) > 0) ||
//         (result.containsKey('nMatched') &&
//             ((result['nMatched'] as int?) ?? 0) > 0);
//   }

  Future<String?> _getCurrentPassword(ObjectId objectId) async {
    final response = await _collection.findOne(
      where.eq(KeysEnum.id.valueKey, objectId).fields([
        KeysEnum.password.valueKey,
      ]),
    );

    return response?[KeysEnum.password.valueKey]?.toString();
  }

  bool _verifyOldPassword(String encryptedPassword, String oldPassword) {
    final decryptedPassword =
        EncryptionHelper.decryptPassword(encryptedPassword);
    return oldPassword == decryptedPassword;
  }

  Future<bool> _updatePasswordInDb(
    ObjectId objectId,
    String newPassword,
  ) async {
    final encryptedPassword = EncryptionHelper.encryptPassword(newPassword);

    final result = await _collection.updateOne(
      where.eq(KeysEnum.id.valueKey, objectId),
      modify.set(KeysEnum.password.valueKey, encryptedPassword),
    );

    return result.isSuccess;
  }
}
