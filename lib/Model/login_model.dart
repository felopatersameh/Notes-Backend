import 'package:notes/Enum/keys_enum.dart';
import 'package:notes/utils/custom_messages.dart';
import 'package:sahih_validator/sahih_validator.dart';

class LoginModel {
  LoginModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      KeysEnum.email.valueKey: email,
      KeysEnum.password.valueKey: password,
    };
  }

  static Map<bool, Object> fromMapValidate(Map<String, dynamic> map) {
    final email = (map[KeysEnum.email.valueKey] ?? '').toString().trim();
    final password = (map[KeysEnum.password.valueKey] ?? '').toString().trim();

    // Validate email
    if (email.isEmpty) {
      return {
        false: CustomMessages.emailRequired,
      };
    }

    final emailError = SahihValidator.email(
      email: email,
      emptyMessage: CustomMessages.emailRequired,
      invalidFormatMessage: CustomMessages.emailInvalid,
    );

    if (emailError != null) {
      return {
        false: emailError,
      };
    }

    // Validate password (only check if not empty for login)
    final passwordError = SahihValidator.loginPassword(
      password: password,
      emptyMessage: CustomMessages.passwordRequired,
    );

    if (passwordError != null) {
      return {
        false: passwordError,
      };
    }

    final model = LoginModel(
      email: email,
      password: password,
    );

    return {
      true: model,
    };
  }
}
