import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/Enum/methods_enum.dart';
import 'package:notes/Enum/role_enum.dart';
import 'package:notes/repositories/user_repository.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:notes/utils/my_response_model.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.put => await updateRole(id, context),
    _ => await MyResponseModel.error(
        statusCode: HttpStatus.methodNotAllowed,
        message: CustomMessages.methodsAllowed(
          methods: [MethodsEnum.put],
        ),
      )
  };
}

Future<Response> updateRole(String userId, RequestContext context) async {
  try {
    final json = (await context.request.json()) as Map<String, dynamic>;
    final role = json[KeysEnum.role.valueKey]?.toString().trim() ?? '';

    if (role.isEmpty) {
      return MyResponseModel.error(
        statusCode: HttpStatus.badRequest,
        message: CustomMessages.roleRequired,
      );
    }
    final roleIsFound = RoleEnum.isValid(role);
    if (!roleIsFound) {
      return MyResponseModel.error(
        statusCode: HttpStatus.badRequest,
        message: CustomMessages.roleInvalid,
      );
    }
    final repo = context.read<UserRepository>();
    final success = await repo.updateRole(userId, role);

    if (!success) {
      return MyResponseModel.error(
        statusCode: HttpStatus.internalServerError,
        message: CustomMessages.failedToUpdateRole,
      );
    }

    return MyResponseModel.success(
      message: CustomMessages.roleUpdatedSuccessfully,
    );
  } catch (e) {
    return MyResponseModel.error(
      statusCode: HttpStatus.internalServerError,
      message: '${CustomMessages.failedToUpdateRole} $e',
    );
  }
}
