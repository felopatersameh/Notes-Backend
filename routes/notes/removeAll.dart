import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/methods_enum.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final authData = context.read<AuthData>();

  return switch (context.request.method) {
    HttpMethod.delete => await clearAllNotes(authData.userId, context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(methods: [MethodsEnum.delete]),
      )
  };
}

Future<Response> clearAllNotes(String userId, RequestContext context) async {
  final repo = context.read<NotesRepository>();
  final success = await repo.clearAllNotes(userId);

  if (!success) {
    return MyResponseModel.error(
      statusCode: HttpStatus.internalServerError,
      message: CustomMessages.failedToClearNotes,
    );
  }

  return MyResponseModel.success(
    message: CustomMessages.allNotesClearedSuccessfully,
  );
}
