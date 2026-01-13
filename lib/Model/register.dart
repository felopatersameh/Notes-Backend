// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Model/notes_model.dart';

class RegisterModel {
  final String? name;
  final String? email;
  final String? password;
  RegisterModel({
    this.name,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      KeysEnum.name.valueKey: name,
      KeysEnum.email.valueKey: email,
      KeysEnum.password.valueKey: password,
      KeysEnum.notes.valueKey: <NotesModel>[],
      KeysEnum.createAt.valueKey: DateTime.now().toIso8601String(),
    };
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      name: map[KeysEnum.name.valueKey] != null
          ? map[KeysEnum.name.valueKey] as String
          : null,
      email: map[KeysEnum.email.valueKey] != null
          ? map[KeysEnum.email.valueKey] as String
          : null,
      password: map[KeysEnum.password.valueKey] != null
          ? map[KeysEnum.password.valueKey] as String
          : null,
    );
  }

  RegisterModel copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return RegisterModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
