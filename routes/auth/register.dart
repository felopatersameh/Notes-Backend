import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Enum/methods_enum.dart';
import 'package:notes/Model/register.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:sahih_validator/sahih_validator.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => await registerUser(context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(methods: [MethodsEnum.post]),
      )
  };
}

Future<Response> registerUser(RequestContext context) async {
  final data = await context.request.json() as Map<String, dynamic>;
  final model = RegisterModel.fromMap(data);

  // Check required fields
  if (model.name == null || model.email == null || model.password == null) {
    return MyResponseModel.error(
      statusCode: HttpStatus.badRequest,
      message: CustomMessages.registerFieldsRequired,
    );
  }

  final email = model.email!.trim();
  final password = model.password!;

  // Validate email
  if (email.isEmpty) {
    return MyResponseModel.error(
      statusCode: HttpStatus.badRequest,
      message: CustomMessages.emailRequired,
    );
  }

  final emailError = SahihValidator.email(
    email: email,
    emptyMessage: CustomMessages.emailRequired,
    invalidFormatMessage: CustomMessages.emailInvalid,
  );

  if (emailError != null) {
    return MyResponseModel.error(
      statusCode: HttpStatus.badRequest,
      message: emailError,
    );
  }

  // Validate password
  if (password.isEmpty) {
    return MyResponseModel.error(
      statusCode: HttpStatus.badRequest,
      message: CustomMessages.passwordRequired,
    );
  }

  final passwordError = SahihValidator.passwordParts(password);

  if (passwordError != null) {
    return MyResponseModel.error(
      statusCode: HttpStatus.badRequest,
      message: passwordError,
    );
  }

  final repo = context.read<UserRepository>();
  final result = await repo.register(model);

  if (!(result['success'] as bool)) {
    return MyResponseModel.error(
      statusCode: HttpStatus.conflict,
      message: result[KeysEnum.message.valueKey].toString(),
    );
  }

  return MyResponseModel.success(
    statusCode: HttpStatus.created,
    message: result[KeysEnum.message.valueKey].toString(),
  );
}
