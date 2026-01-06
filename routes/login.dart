import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:notes/Enum/collections_enum.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Model/login_model.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => await loginUser(context),
    _ => Response(body: 'This is a new route!')
  };
}

Future<Response> loginUser(RequestContext context) async {
  final data = await context.request.json() as Map<String, dynamic>;
  final result = LoginModel.fromMapValidate(data);
  if (result.containsKey(false)) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: (result[false] ?? '') as String,
    );
  }
  final modelResult = result[true]! as LoginModel;
  final db = context.read<Db>().collection(CollectionsEnum.user.valueKey);
  final isExits = await db.findOne(
    where
        .eq(
      KeysEnum.email.valueKey,
      modelResult.email,
    )
        .fields([KeysEnum.password.valueKey, KeysEnum.id.valueKey]),
  );

  final password = isExits?[KeysEnum.password.valueKey] == modelResult.password;
  if (isExits != null && password) {
    return Response.json(
      body: {
        KeysEnum.id.valueKey: isExits[KeysEnum.id.valueKey],
      },
    );
  } else {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'message': 'invalid password or email'},
    );
  }
}
