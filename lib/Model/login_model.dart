// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:notes/Enum/keys_enum.dart';

class LoginModel {
  LoginModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      KeysEnum.email.valueKey: email,
      KeysEnum.password.valueKey: password,
    };
  }

  factory LoginModel._fromMap(Map<String, dynamic> map) {
    return LoginModel(
      email: (map[KeysEnum.email.valueKey] ?? '') as String,
      password: (map[KeysEnum.password.valueKey] ?? '') as String,
    );
  }

  static Map<bool, Object> fromMapValidate(Map<String, dynamic> map) {
    final model = LoginModel._fromMap(map);
    if (model.email == '' || model.password == '') {
      return {
        false: 'parms is requerid',
      };
    } else {
      return {
        true: model,
      };
    }
  }
}
