import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Enum/methods_enum.dart';
import 'package:notes/Model/login_model.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => await loginUser(context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(methods: [MethodsEnum.post]),
      )
  };
}

Future<Response> loginUser(RequestContext context) async {
  final data = await context.request.json() as Map<String, dynamic>;

  final result = LoginModel.fromMapValidate(data);
  if (result.containsKey(false)) {
    return MyResponseModel.error(
      statusCode: HttpStatus.badRequest,
      message: result[false].toString(),
    );
  }

  final model = result[true]! as LoginModel;
  final repo = context.read<UserRepository>();
  final user = await repo.login(model);

  if (user == null) {
    return MyResponseModel.error(
      statusCode: HttpStatus.unauthorized,
      message: CustomMessages.invalidEmailPassword,
    );
  }

  return MyResponseModel.success(
    message: CustomMessages.loginSuccess,
    body: {
      KeysEnum.token.valueKey: user[KeysEnum.token.valueKey],
    },
  );
}
