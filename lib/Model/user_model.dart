// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:notes/Enum/keys_enum.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  // final String password;
  final String created;
  // final List<NotesModel> notes;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    // required this.password,
    required this.created,
    // required this.notes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      KeysEnum.id.valueKey: id,
      KeysEnum.name.valueKey: name,
      KeysEnum.email.valueKey: email,
      // KeysEnum.password.valueKey: password,
      KeysEnum.createAt.valueKey: created,
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
      // notes: map[KeysEnum.notes.valueKey] != null
      //     ? (map[KeysEnum.notes.valueKey] as List<dynamic>)
      //         .map((x) => NotesModel.fromMap(x as Map<String, dynamic>))
      //         .toList()
      //     : [],
    );
  }
}
