import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getAllList(context),
    HttpMethod.post => _addedList(context),
    _ => Future.value(Response(statusCode: HttpStatus.notFound)),
  };
}

Future<Response> _getAllList(RequestContext context) async {
  final users = await context.read<Db>().collection('users').find().toList();

  return Response.json(body: users);
}

Future<Response> _addedList(RequestContext context) async {
  final data = await context.request.json() as Map<String, dynamic>;

  final name = data['name'] as String?;
  if (name == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'name is required'},
    );
  }

  final result =
      await context.read<Db>().collection('users').insertOne({'name': name});

  return Response.json(
    body: {
      'id': result.id.toString(),
      'data': result.document,
    },
  );
}
