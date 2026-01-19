// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Enum/methods_enum.dart';
import 'package:notes/Model/update_user_model.dart';
import 'package:notes/Model/user_model.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';
import 'package:notes/utils/tokens.dart';

Future<Response> onRequest(RequestContext context) async {
  final authData = context.read<AuthData>();

  return switch (context.request.method) {
    HttpMethod.get => await getUser(authData.userId, context),
    HttpMethod.put => await updateUser(authData.userId, context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(
          methods: [MethodsEnum.get, MethodsEnum.put],
        ),
      )
  };
}

Future<Response> getUser(String userId, RequestContext context) async {
  final repo = context.read<UserRepository>();
  final result = await repo.getUserData(userId);

  if (result == null) {
    return MyResponseModel.error(
      statusCode: HttpStatus.notFound,
      message: CustomMessages.userNotFound,
    );
  }

  final model = UserModel.fromUser(result);

  return MyResponseModel.success(
    message: CustomMessages.userRetrievedSuccessfully,
    body: model.toUser(),
  );
}

Future<Response> updateUser(String userId, RequestContext context) async {
  try {
    final json = await context.request.json() as Map<String, dynamic>;

    if (json.isEmpty) {
      return await MyResponseModel.error(
        statusCode: HttpStatus.badRequest,
        message: CustomMessages.noDataProvidedForUpdate,
      );
    }

    final repo = context.read<UserRepository>();
    final model = UpdateUserModel.fromMap(json);
    final result = await repo.updateAccount(userId, model);

    if (result == null) {
      return await MyResponseModel.error(
        statusCode: HttpStatus.internalServerError,
        message: CustomMessages.failedToUpdateUser,
      );
    }

    final success = result['success'] as bool? ?? false;

    if (!success) {
      return await MyResponseModel.error(
        statusCode: HttpStatus.badRequest,
        message: result[KeysEnum.message.valueKey]?.toString() ??
            CustomMessages.failedToUpdateUser,
      );
    }

    return await MyResponseModel.success(
      message: result[KeysEnum.message.valueKey]?.toString() ??
          CustomMessages.userUpdatedSuccessfully,
    );
  } catch (e) {
    return MyResponseModel.error(
      statusCode: HttpStatus.badRequest,
      message: CustomMessages.invalidDataFormat,
    );
  }
}
