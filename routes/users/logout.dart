import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final authData = context.read<AuthData>();

  return switch (context.request.method) {
    HttpMethod.post => await logout(authData.token, context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(methods: [MethodsEnum.post]),
      )
  };
}

Future<Response> logout(String token, RequestContext context) async {
  final repo = context.read<UserRepository>();
  final success = await repo.logout(token);

  if (!success) {
    return MyResponseModel.error(
      statusCode: HttpStatus.internalServerError,
      message: CustomMessages.failedToLogout,
    );
  }

  return MyResponseModel.success(
    message: CustomMessages.loggedOutSuccessfully,
  );
}
