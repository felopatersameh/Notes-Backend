import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Enum/role_enum.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  // final String password;
  final String? created;
  // final List<NotesModel> notes;

  UserModel({
     this.id,
     this.name,
     this.email,
    // required this.password,
     this.created,
    this.role,
    // required this.notes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      KeysEnum.id.valueKey: id,
      KeysEnum.name.valueKey: name,
      KeysEnum.email.valueKey: email,
      // KeysEnum.password.valueKey: password,
      KeysEnum.createAt.valueKey: created,
      KeysEnum.role.valueKey: RoleEnum.fromValue(role??''),
      // KeysEnum.notes.valueKey: notes.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[KeysEnum.id.valueKey] as String,
      name: map[KeysEnum.name.valueKey] as String,
      email: map[KeysEnum.email.valueKey] as String,
      // password: map[KeysEnum.password.valueKey] as String,
      created: map[KeysEnum.createAt.valueKey] as String,
      role: RoleEnum.fromValue(map[KeysEnum.role.valueKey].toString()),
      // notes: map[KeysEnum.notes.valueKey] != null
      //     ? (map[KeysEnum.notes.valueKey] as List<dynamic>)
      //         .map((x) => NotesModel.fromMap(x as Map<String, dynamic>))
      //         .toList()
      //     : [],
    );
  }
  factory UserModel.fromUser(Map<String, dynamic> map) {
    return UserModel(
      // id: map[KeysEnum.id.valueKey] as String,
      name: map[KeysEnum.name.valueKey] as String,
      email: map[KeysEnum.email.valueKey] as String,
      // password: map[KeysEnum.password.valueKey] as String,
      created: map[KeysEnum.createAt.valueKey] as String,
      role: RoleEnum.fromValue(map[KeysEnum.role.valueKey].toString()),
      // notes: map[KeysEnum.notes.valueKey] != null
      //     ? (map[KeysEnum.notes.valueKey] as List<dynamic>)
      //         .map((x) => NotesModel.fromMap(x as Map<String, dynamic>))
      //         .toList()
      //     : [],
    );
  }
    Map<String, dynamic> toUser() {
    return <String, dynamic>{
      KeysEnum.name.valueKey: name,
      KeysEnum.email.valueKey: email,
      // KeysEnum.password.valueKey: password,
      KeysEnum.createAt.valueKey: created,
      KeysEnum.role.valueKey: RoleEnum.fromValue(role??''),
      // KeysEnum.notes.valueKey: notes.map((x) => x.toMap()).toList(),
    };
  }
}
