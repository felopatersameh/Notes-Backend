// ignore_for_file: public_member_api_docs, sort_constructors_first

enum KeysEnum {
  id(valueKey: '_id'),
  email(valueKey: 'email'),
  password(valueKey: 'password');

  final String valueKey;

  const KeysEnum({required this.valueKey});
}
