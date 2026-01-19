import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/methods_enum.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.delete => await deleteUser(id, context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(
          methods: [MethodsEnum.delete],
        ),
      )
  };
}

Future<Response> deleteUser(String userId, RequestContext context) async {
  final repo = context.read<UserRepository>();
  final success = await repo.deleteAccount(userId);

  if (!success) {
    return MyResponseModel.error(
      statusCode: HttpStatus.internalServerError,
      message: CustomMessages.failedToDeleteAccount,
    );
  }

  return MyResponseModel.success(
    message: CustomMessages.accountDeletedSuccessfully,
  );
}
