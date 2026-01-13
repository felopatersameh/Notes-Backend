
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final authData = context.read<AuthData>();
  
  return switch (context.request.method) {
    HttpMethod.delete => await _clearAllNotes(authData.userId, context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {
          KeysEnum.message.valueKey: 'Allowed method: DELETE',
        },
      )
  };
}

Future<Response> _clearAllNotes(String userId, RequestContext context) async {
  final repo = context.read<NotesRepository>();
  final success = await repo.clearAllNotes(userId);

  return Response.json(
    statusCode: success ? HttpStatus.ok : HttpStatus.internalServerError,
    body: {
      KeysEnum.message.valueKey: success 
          ? 'All notes cleared successfully' 
          : 'Failed to clear notes',
    },
  );
}
