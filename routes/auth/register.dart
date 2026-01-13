// ignore_for_file: eol_at_end_of_file

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Model/register.dart';
import 'package:notes/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => await registerUser(context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
      )
  };
}

Future<Response> registerUser(RequestContext context) async {
  final data = await context.request.json() as Map<String, dynamic>;
  final model = RegisterModel.fromMap(data);

  if (model.name == null || model.email == null || model.password == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        KeysEnum.message.valueKey:
            'fields "name", "email", "password" are required',
      },
    );
  }

  final repo = context.read<UserRepository>();
  final result = await repo.register(model);

  if (!(result['success'] as bool)) {
    return Response.json(
      statusCode: HttpStatus.conflict,
      body: {
        KeysEnum.message.valueKey: result[KeysEnum.message.valueKey],
      },
    );
  }

  return Response.json(
    statusCode: HttpStatus.created,
    body: {
      KeysEnum.message.valueKey: result[KeysEnum.message.valueKey],
    },
  );
}
