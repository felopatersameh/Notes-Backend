// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final data = context.read<AuthData>();

  return switch (context.request.method) {
    HttpMethod.delete => await removeUser(data, context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(methods: [MethodsEnum.delete]),
      )
  };
}

Future<Response> removeUser(AuthData authData, RequestContext context) async {
  final repo = context.read<UserRepository>();
  final success = await repo.deleteAccount(authData.userId);

  if (success) {
    await repo.logout(authData.token);
  }

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
