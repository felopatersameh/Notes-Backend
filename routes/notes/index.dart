import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(
  RequestContext context,
) async {
  final idUser = context.read<AuthData>().userId;
  return switch (context.request.method) {
    HttpMethod.get => await getNotesUser(idUser, context),
    HttpMethod.post => await addedNotes(idUser, context),
    HttpMethod.put => await updateNotes(idUser, context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: 'get/post/put/delete',
      )
  };
}



Future<Response> addedNotes(String id, RequestContext context) async {
  final json = await context.request.json() as Map<String, dynamic>;
  final map = {
    KeysEnum.body.valueKey: json[KeysEnum.body.valueKey],
    KeysEnum.subject.valueKey: (json[KeysEnum.subject.valueKey] ?? ''),
  };
  final repo = context.read<NotesRepository>();
  final result = await repo.addNote(id, map);
  if (result == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        KeysEnum.message.valueKey: 'SomeThing Error check your input is null',
      },
    );
  }
  return Response.json(
    body: result.toMap(),
  );
}


Future<Response> updateNotes(String id, RequestContext context) async {
final json = await context.request.json() as Map<String, dynamic>;
  final map = {
    KeysEnum.idNotes.valueKey: json[KeysEnum.idNotes.valueKey],
    KeysEnum.body.valueKey: json[KeysEnum.body.valueKey],
    KeysEnum.subject.valueKey: (json[KeysEnum.subject.valueKey] ?? ''),
  };
  final repo = context.read<NotesRepository>();
  final result = await repo.updateNotePart(id, map);
  if (result == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        KeysEnum.message.valueKey: 'SomeThing Error check your input is null',
      },
    );
  }
  return Response.json(
    body: result,
  );
}

Future<Response> getNotesUser(String id, RequestContext context) async {
  final repo = context.read<NotesRepository>();
  final result = await repo.getNotes(id);
  return Response.json(
    body: {
      KeysEnum.data.valueKey: [...result.toSet()],
    },
  );
}
