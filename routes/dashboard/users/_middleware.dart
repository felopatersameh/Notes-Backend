import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/role_enum.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:notes/utils/tokens.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final authData = context.read<AuthData>();

    if (authData.role != RoleEnum.admin.valueKey) {
      return MyResponseModel.error(
        statusCode: HttpStatus.forbidden,
        message: 'Admins only',
      );
    }

    return handler(context);
  };
}
