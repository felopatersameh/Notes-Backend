import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:notes/Model/register.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => await registerUser(context),
    _ => Response(statusCode: HttpStatus.notFound)
  };
}

Future<Response> registerUser(RequestContext context) async {
  final data = await context.request.json() as Map<String, dynamic>;
  final model = RegisterModel.fromMap(data);
  if (model.name == null || model.email == null || model.password == null) {
    return Future.value(
      Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'message': 'please this fields is reguired "name","email","password"',
        },
      ),
    );
  }
  final db = context.read<Db>().collection('users');
  final isExist = await db.findOne(
    where.eq('email', model.email),
  );

  if (isExist != null) {
    return Future.value(
      Response.json(
        statusCode: HttpStatus.conflict,
        body: 'Email is Already Founded',
      ),
    );
  }
  final response = await db.insertOne(model.toMap());
  return Future.value(Response.json(body: response.id));
}
