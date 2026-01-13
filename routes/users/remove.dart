// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final data = context.read<AuthData>();


  return switch (context.request.method) {
    HttpMethod.delete => await _removeUser(data, context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {
          KeysEnum.message.valueKey: 'Allowed methods:  DELETE',
        },
      )
  };
}

Future<Response> _removeUser(AuthData authData, RequestContext context) async {
  final repo = context.read<UserRepository>();
  final success = await repo.deleteAccount(authData.userId);
  
  if (success) {
    await repo.logout(authData.token);
  }
  
  return Response.json(
    statusCode: success ? HttpStatus.ok : HttpStatus.internalServerError,
    body: {
      KeysEnum.message.valueKey: success 
          ? 'Account deleted successfully' 
          : 'Failed to delete account',
    },
  );
}
