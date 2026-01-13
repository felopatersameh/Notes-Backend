import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(
  RequestContext context,
  String idNote,
) async {
  final idUser = context.read<AuthData>().userId;
  return switch (context.request.method) {
    HttpMethod.delete => await removeNotes(idUser, idNote, context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: 'delete',
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
