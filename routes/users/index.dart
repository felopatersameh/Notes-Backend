// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Model/update_user_model.dart';
import 'package:notes/Model/user_model.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final authData = context.read<AuthData>();
  
  return switch (context.request.method) {
    HttpMethod.get => await _getUser(authData.userId, context),
    HttpMethod.put => await _updateUser(authData.userId, context),
    _ => Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {
          KeysEnum.message.valueKey: 'Allowed methods: GET, PUT, DELETE',
        },
      )
  };
}

Future<Response> _getUser(String userId, RequestContext context) async {
  final repo = context.read<UserRepository>();
  final result = await repo.getUserData(userId);
  
  if (result == null) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {
        KeysEnum.message.valueKey: 'User not found',
        KeysEnum.data.valueKey: null,
      },
    );
  }
  
  final model = UserModel.fromMap(result);
  
  return Response.json(
    body: {
      KeysEnum.message.valueKey: 'User retrieved successfully',
      KeysEnum.data.valueKey: model.toMap(),
    },
  );
}

Future<Response> _updateUser(String userId, RequestContext context) async {
  try {
    final json = await context.request.json() as Map<String, dynamic>;
    
    if (json.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          KeysEnum.message.valueKey: 'No data provided for update',
        },
      );
    }
    
    final repo = context.read<UserRepository>();
    final model = UpdateUserModel.fromMap(json);
    final result = await repo.updateAccount(userId, model);
    return Response.json(
      body: result,
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        KeysEnum.message.valueKey: 'Invalid data format',
        KeysEnum.data.valueKey: null,
      },
    );
  }
}


