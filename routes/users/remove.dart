// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final userId = context.read<AuthData>().userId;


  return switch (context.request.method) {
    HttpMethod.delete => await _deleteAccount(userId, context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {
          KeysEnum.message.valueKey: 'Allowed methods: POST, DELETE',
        },
      )
  };
}

Future<Response> _deleteAccount(String userId, RequestContext context) async {
  final authHeader = context.request.headers['authorization'];

  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {
        KeysEnum.message.valueKey: 'Unauthorized',
      },
    );
  }

  final token = authHeader.substring(7);
  final repo = context.read<UserRepository>();

  final success = await repo.deleteAccount(userId);

  if (success) {
    await repo.logout(token);
  }

  return Response.json(
    statusCode: success ? HttpStatus.ok : HttpStatus.internalServerError,
    body: {
      KeysEnum.message.valueKey:
          success ? 'Account deleted successfully' : 'Failed to delete account',
    },
  );
}
