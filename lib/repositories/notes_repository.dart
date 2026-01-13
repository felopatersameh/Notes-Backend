import 'package:mongo_dart/mongo_dart.dart';
import 'package:nanoid/async.dart';
import 'package:notes/Enum/collections_enum.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Model/notes_model.dart';

class NotesRepository {
  NotesRepository(this.db) {
    _collection = db.collection(CollectionsEnum.user.valueKey);
  }

  final Db db;
  late final DbCollection _collection;

  Future<List<dynamic>> getNotes(String userId) async {
    try {
      final objectId = _convertToObjectId(userId);
      final result = await _collection.findOne(
        where
            .eq(KeysEnum.id.valueKey, objectId)
            .fields([KeysEnum.notes.valueKey]),
      );

      if (result == null) return [];

      final notesList = result[KeysEnum.notes.valueKey] as List<dynamic>?;
      return notesList ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<NotesModel?> addNote(
    String userId,
    Map<String, dynamic> noteMap,
  ) async {
    try {
      final objectId = _convertToObjectId(userId);
      final note = NotesModel.fromMap(noteMap, id: await nanoid(6));
      
      final result = await _collection.updateOne(
        where.eq(KeysEnum.id.valueKey, objectId),
        modify.push(KeysEnum.notes.valueKey, note.toMap()),
      );

      return result.isSuccess ? note : null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateNotePart(
    String userId,
    Map<String, dynamic> updatedFields,
  ) async {
    try {
      final noteId = updatedFields[KeysEnum.idNotes.valueKey] as String?;
      if (noteId == null) return null;

      final updatedNewFields = {
        KeysEnum.updateAt.valueKey: DateTime.now().toIso8601String(),
        ...updatedFields,
      };

      final objectId = _convertToObjectId(userId);
      final modifier = _buildUpdateModifier(updatedNewFields);

      final result = await _collection.updateOne(
        where.eq(KeysEnum.id.valueKey, objectId).eq(
              '${KeysEnum.notes.valueKey}.${KeysEnum.idNotes.valueKey}',
              noteId,
            ),
        modifier,
      );

      return result.isSuccess ? updatedNewFields : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> removeNote(String userId, String noteId) async {
    try {
      final objectId = _convertToObjectId(userId);
      
      final result = await _collection.updateOne(
        where.eq(KeysEnum.id.valueKey, objectId),
        modify.pull(
          KeysEnum.notes.valueKey,
          {KeysEnum.idNotes.valueKey: noteId},
        ),
      );

      return result.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearAllNotes(String userId) async {
    try {
      final objectId = _convertToObjectId(userId);
      
      final result = await _collection.updateOne(
        where.eq(KeysEnum.id.valueKey, objectId),
        modify.set(KeysEnum.notes.valueKey, <dynamic>[]),
      );

      return result.isSuccess;
    } catch (e) {
      return false;
    }
  }

  ObjectId _convertToObjectId(String id) {
    return ObjectId.fromHexString(id);
  }

  ModifierBuilder _buildUpdateModifier(Map<String, dynamic> fields) {
    var modifier = ModifierBuilder();
    fields.forEach((key, value) {
      modifier = modifier.set('${KeysEnum.notes.valueKey}.\$.$key', value);
    });
    return modifier;
  }
}
