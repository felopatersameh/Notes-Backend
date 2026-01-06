// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotesModel {
  final String id;
  final String subject;
  final String body;
  final String createdAt;
  final String updatedAt;
  final List<String> colors;
  NotesModel({
    required this.id,
    required this.subject,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.colors,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'subject': subject,
      'body': body,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'colors': colors,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'] as String,
      subject: map['subject'] as String,
      body: map['body'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      colors: List<String>.from(
        map['colors'] as List<String>,
      ),
    );
  }

}
