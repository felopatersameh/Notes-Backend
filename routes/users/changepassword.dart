import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:notes/utils/tokens.dart';
import 'package:sahih_validator/sahih_validator.dart';

Future<Response> onRequest(RequestContext context) async {
  final userId = context.read<AuthData>().userId;

  return switch (context.request.method) {
    HttpMethod.put => await changePassword(userId, context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(methods: [MethodsEnum.put]),
      )
  };
}

Future<Response> changePassword(String id, RequestContext context) async {
  try {
    final json = await context.request.json() as Map<String, dynamic>;
    final old = json[KeysEnum.password.valueKey]?.toString() ?? '';
    final current = json[KeysEnum.newPassword.valueKey]?.toString() ?? '';

    // Validate old password is provided
    if (old.isEmpty) {
      return await MyResponseModel.error(
        statusCode: HttpStatus.badRequest,
        message: CustomMessages.passwordRequired,
      );
    }

    // Validate new password is provided
    if (current.isEmpty) {
      return await MyResponseModel.error(
        statusCode: HttpStatus.badRequest,
        message: CustomMessages.newPasswordRequired,
      );
    }

    // Validate new password strength
    final passwordError = SahihValidator.passwordParts(current);

    if (passwordError != null) {
      return await MyResponseModel.error(
        statusCode: HttpStatus.badRequest,
        message: passwordError,
      );
    }

    final repo = context.read<UserRepository>();
    final result = await repo.updatePassword(id, old, current);

    if (!result) {
      return await MyResponseModel.error(
        statusCode: HttpStatus.notAcceptable,
        message: CustomMessages.oldPasswordIncorrect,
      );
    }

    return await MyResponseModel.success(
      message: CustomMessages.passwordChangedSuccessfully,
    );
  } catch (e) {
    return MyResponseModel.error(
      message: e.toString(),
    );
  }
}
