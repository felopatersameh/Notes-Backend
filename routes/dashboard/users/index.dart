import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/methods_enum.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final auth = context.read<AuthData>();
  return switch (context.request.method) {
    HttpMethod.get => await getUsers(context,auth.userId),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(
          methods: [MethodsEnum.get],
        ),
      )
  };
}

Future<Response> getUsers(RequestContext context,String id) async {
  final repo = context.read<UserRepository>();
  final users = await repo.getAllUsers(id);

  if (users == null) {
    return MyResponseModel.error(
      statusCode: HttpStatus.internalServerError,
      message: CustomMessages.failedToRetrieveUsers,
    );
  }

  return MyResponseModel.success(
    message: CustomMessages.usersRetrievedSuccessfully,
    body: users,
  );
}
