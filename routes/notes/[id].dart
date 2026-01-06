import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => await getNotesUser(id),
    HttpMethod.put => await updateNotes(id, context),
    HttpMethod.delete => await removeNotes(id, context),
    _ => Response(body: 'This is a new route!')
  };
}

Future<Response> removeNotes(String id, RequestContext context) async {
  return Future.value(Response.json(body: {'data': 'id $id'}));
}

Future<Response> updateNotes(String id, RequestContext context) async {
  final json = await context.request.json();
  return Future.value(
    Response.json(
      body: 'update $id , $json',
    ),
  );
}

Future<Response> getNotesUser(String id) async {
  return Future.value(Response.json(body: {'data': 'id $id'}));
}
