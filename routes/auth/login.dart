import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Model/login_model.dart';
import 'package:notes/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => await loginUser(context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        )
  };
}

Future<Response> loginUser(RequestContext context) async {
  final data = await context.request.json() as Map<String, dynamic>;

  final result = LoginModel.fromMapValidate(data);
  if (result.containsKey(false)) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: result[false],
    );
  }

  final model = result[true]! as LoginModel;
  final repo = context.read<UserRepository>();
  final user = await repo.login(model);

  if (user == null) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {KeysEnum.message.valueKey: 'invalid email or password'},
    );
  }

  return Response.json(
    body: {
      KeysEnum.token.valueKey: user[KeysEnum.token.valueKey],
    },
  );
}
