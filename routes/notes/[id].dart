import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(
  RequestContext context,
  String idNote,
) async {
  final idUser = context.read<AuthData>().userId;
  return switch (context.request.method) {
    HttpMethod.put => await _updateNote(idUser, idNote, context),
    HttpMethod.delete => await removeNotes(idUser, idNote, context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {
          KeysEnum.message.valueKey: 'Allowed methods: PUT, DELETE',
        },
      )
  };
}

Future<Response> removeNotes(
  String id,
  String idNotes,
  RequestContext context,
) async {
  final repo = context.read<NotesRepository>();
  final result = await repo.removeNote(id, idNotes);
  return Future.value(Response.json(body: {'data': result}));
}

Future<Response> _updateNote(
  String userId,
  String idNotes,
  RequestContext context,
) async {
  final json = await context.request.json() as Map<String, dynamic>;

  final updateData = {
    KeysEnum.idNotes.valueKey: idNotes,
    if (json[KeysEnum.body.valueKey] != null)
      KeysEnum.body.valueKey: json[KeysEnum.body.valueKey],
    if (json[KeysEnum.subject.valueKey] != null)
      KeysEnum.subject.valueKey: json[KeysEnum.subject.valueKey],
  };

  final repo = context.read<NotesRepository>();
  final result = await repo.updateNotePart(userId, updateData);

  if (result == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {
        KeysEnum.message.valueKey: 'Note not found or failed to update',
      },
    );
  }

  return Response.json(
    body: result,
  );
}
