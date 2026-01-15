import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final userId = context.read<AuthData>().userId;

  return switch (context.request.method) {
    HttpMethod.get => await getNotes(userId, context),
    HttpMethod.post => await addNote(userId, context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(
          methods: [MethodsEnum.get, MethodsEnum.post],
        ),
      )
  };
}

Future<Response> getNotes(String userId, RequestContext context) async {
  final repo = context.read<NotesRepository>();
  final notes = await repo.getNotes(userId);

  return MyResponseModel.success(
    message: CustomMessages.notesRetrievedSuccessfully,
    body: notes,
  );
}

Future<Response> addNote(String userId, RequestContext context) async {
  final json = await context.request.json() as Map<String, dynamic>;

  if (json[KeysEnum.body.valueKey] == null) {
    return MyResponseModel.error(
      statusCode: HttpStatus.badRequest,
      message: CustomMessages.fieldBodyRequired,
    );
  }

  final noteData = {
    KeysEnum.body.valueKey: json[KeysEnum.body.valueKey],
    KeysEnum.subject.valueKey: json[KeysEnum.subject.valueKey] ?? '',
  };

  final repo = context.read<NotesRepository>();
  final result = await repo.addNote(userId, noteData);

  if (result == null) {
    return MyResponseModel.error(
      statusCode: HttpStatus.internalServerError,
      message: CustomMessages.failedToAddNote,
    );
  }

  return MyResponseModel.success(
    statusCode: HttpStatus.created,
    message: CustomMessages.noteAddedSuccessfully,
    body: result.toMap(),
  );
}
