import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final authData = context.read<AuthData>();

  return switch (context.request.method) {
    HttpMethod.post => await _logout(authData.token,context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {
          KeysEnum.message.valueKey: 'Allowed methods: POST, DELETE',
        },
      )
  };
}

Future<Response> _logout(String token ,RequestContext context) async {
  final repo = context.read<UserRepository>();
  final success = await repo.logout(token);

  return Response.json(
    statusCode: success ? HttpStatus.ok : HttpStatus.internalServerError,
    body: {
      KeysEnum.message.valueKey:
          success ? 'Logged out successfully' : 'Failed to logout',
    },
  );
}
