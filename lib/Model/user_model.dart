// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:notes/Model/notes_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final int created;
  final List<NotesModel> notes;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.created,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'created': created,
      'notes': notes.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      created: map['created'] as int,
      notes: List<NotesModel>.from(
        (map['notes'] as List<int>).map<NotesModel>(
          (x) => NotesModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }


}
