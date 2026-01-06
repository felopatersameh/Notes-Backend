import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => await getUser(id),
    HttpMethod.put => await updateUser(id, context),
    HttpMethod.delete => await removeUser(id, context),
    _ => Response(body: 'This is a new route!')
  };
}

Future<Response> removeUser(String id, RequestContext context) async {
  return Future.value(Response.json(body: {'data': 'id $id'}));
}

Future<Response> updateUser(String id, RequestContext context) async {
  final json = await context.request.json();
  return Future.value(
    Response.json(
      body: 'update $id , $json',
    ),
  );
}

Future<Response> getUser(String id) async {
  return Future.value(Response.json(body: {'data': 'id $id'}));
}
