import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final userId = context.read<AuthData>().userId;

  return switch (context.request.method) {
    HttpMethod.get => await _getNotes(userId, context),
    HttpMethod.post => await _addNote(userId, context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {
          KeysEnum.message.valueKey: 'Allowed methods: GET, POST, PUT, DELETE',
        },
      )
  };
}

Future<Response> _getNotes(String userId, RequestContext context) async {
  final repo = context.read<NotesRepository>();
  final notes = await repo.getNotes(userId);

  return Response.json(
    body: {
      KeysEnum.data.valueKey: notes,
    },
  );
}

Future<Response> _addNote(String userId, RequestContext context) async {
  final json = await context.request.json() as Map<String, dynamic>;

  if (json[KeysEnum.body.valueKey] == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        KeysEnum.message.valueKey: 'Field "body" is required',
      },
    );
  }

  final noteData = {
    KeysEnum.body.valueKey: json[KeysEnum.body.valueKey],
    KeysEnum.subject.valueKey: json[KeysEnum.subject.valueKey] ?? '',
  };

  final repo = context.read<NotesRepository>();
  final result = await repo.addNote(userId, noteData);

  if (result == null) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        KeysEnum.message.valueKey: 'Failed to add note',
      },
    );
  }

  return Response.json(
    statusCode: HttpStatus.created,
    body: result.toMap(),
  );
}
