import 'package:notes/Enum/keys_enum.dart';

class NotesModel {
  NotesModel({
    required this.idNote,
    required this.createdAt,
    required this.updatedAt,
    this.subject,
    this.body,
  });

  factory NotesModel.fromMap(Map<String, dynamic> map,{String? id}){
    return NotesModel(
      idNote: (id ?? map[KeysEnum.idNotes.valueKey]) as String,
      subject: (map[KeysEnum.subject.valueKey]??'') as String,
      body: (map[KeysEnum.body.valueKey]??'') as String,
      createdAt: (map[KeysEnum.createAt.valueKey] ??
          DateTime.now().toIso8601String()) as String,
      updatedAt: (map[KeysEnum.updateAt.valueKey] ??
          DateTime.now().toIso8601String()) as String,
    );
  }  
  
  final String idNote;
  final String? subject;
  final String? body;
  final String createdAt;
  final String updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      KeysEnum.idNotes.valueKey: idNote,
      KeysEnum.subject.valueKey: subject,
      KeysEnum.body.valueKey: body,
      KeysEnum.createAt.valueKey: createdAt,
      KeysEnum.updateAt.valueKey: updatedAt,
    };
  }

  NotesModel copyWith({
    String? subject,
    String? body,
    String? updatedAt,
  }) {
    return NotesModel(
      idNote: idNote,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}
