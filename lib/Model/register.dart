import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Enum/role_enum.dart';
import 'package:notes/Model/notes_model.dart';

class RegisterModel {
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  RegisterModel({
    this.name,
    this.email,
    this.password,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      KeysEnum.name.valueKey: name,
      KeysEnum.email.valueKey: email,
      KeysEnum.password.valueKey: password,
      KeysEnum.notes.valueKey: <NotesModel>[],
      KeysEnum.createAt.valueKey: DateTime.now().toIso8601String(),
      KeysEnum.role.valueKey: role??RoleEnum.user.valueKey,
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
      role: (map[KeysEnum.role.valueKey] ?? RoleEnum.user.valueKey).toString(),
    );
  }

  RegisterModel copyWith({
    String? name,
    String? email,
    String? password,
    String? role,
  }) {
    return RegisterModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
