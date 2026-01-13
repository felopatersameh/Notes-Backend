import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final userId = context.read<AuthData>().userId;

  return switch (context.request.method) {
    HttpMethod.put => await changePassword(userId, context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
      )
  };
}

Future<Response> changePassword(String id, RequestContext context) async {
  try {
    final json = await context.request.json() as Map<String, dynamic>;
    final old = json[KeysEnum.password.valueKey].toString();
    final current = json[KeysEnum.newPassword.valueKey].toString();
    final repo = context.read<UserRepository>();
    final result = await repo.updatePassword(id, old, current);
    if (!result) {
      if (!result) {
        return Response.json(
          statusCode: HttpStatus.notAcceptable,
          body: {
            KeysEnum.message.valueKey: 'Old password is incorrect',
          },
        );
      }
    }
    return Response.json(
      body: {
        KeysEnum.message.valueKey: 'Password changed successfully',
      },
    );
  } catch (e) {
    return Response.json(
      body: {
        KeysEnum.message.valueKey: e.toString(),
      },
    );
  }
}
