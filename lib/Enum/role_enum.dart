// ignore_for_file: public_member_api_docs, sort_constructors_first

enum RoleEnum {
  user(valueKey: 'user') ,
  admin(valueKey: 'admin');

  final String valueKey;

  const RoleEnum({required this.valueKey});

  static bool isValid(String role) {
    return RoleEnum.values.any((e) => e.valueKey == role);
  }

  static String fromValue(String role) {
    return RoleEnum.values.firstWhere(
      (e) => e.valueKey == role,
      orElse: () => user,
    ).valueKey;
  }
}
