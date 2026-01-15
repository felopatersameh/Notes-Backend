import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(
  RequestContext context,
  String idNote,
) async {
  final idUser = context.read<AuthData>().userId;
  return switch (context.request.method) {
    HttpMethod.put => await updateNote(idUser, idNote, context),
    HttpMethod.delete => await removeNote(idUser, idNote, context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(
          methods: [MethodsEnum.put, MethodsEnum.delete],
        ),
      )
  };
}

Future<Response> removeNote(
  String id,
  String idNotes,
  RequestContext context,
) async {
  final repo = context.read<NotesRepository>();
  final result = await repo.removeNote(id, idNotes);

  return MyResponseModel.success(
    message: CustomMessages.noteRemovedSuccessfully,
    body: result,
  );
}

Future<Response> updateNote(
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
    return MyResponseModel.error(
      statusCode: HttpStatus.notFound,
      message: CustomMessages.noteNotFoundOrFailedToUpdate,
    );
  }

  return MyResponseModel.success(
    message: CustomMessages.noteUpdatedSuccessfully,
    body: result,
  );
}
