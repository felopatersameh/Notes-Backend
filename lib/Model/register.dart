
// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      'name': name,
      'email': email,
      'password': password,
      'notes':<NotesModel>[],
      'createAt':DateTime.now().toIso8601String() ,
    };
  }

  

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
    );
  }
}
