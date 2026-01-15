import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';

class MyResponseModel {
  // MyResponseModel({required this.message, required this.data});

  static Future<Response> success({
    required String message,
    dynamic body,
    int statusCode = 200,
  }) async {
    return Response.json(
      statusCode: statusCode,
      body: {
        KeysEnum.message.valueKey: message,
        if (body != null) KeysEnum.data.valueKey: body,
      },
    );
  }

  static Future<Response> error({
    required String message,
    dynamic body,
    int statusCode = 200,
  }) async {
    return Response.json(
      statusCode: statusCode,
      body: {
        KeysEnum.message.valueKey: message,
      if (body != null)  KeysEnum.data.valueKey: body,
      },
    );
  }

  // final String message;
  // final dynamic data;
}
