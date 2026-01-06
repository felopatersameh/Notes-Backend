// ignore_for_file: public_member_api_docs, sort_constructors_first

enum CollectionsEnum {
  user(valueKey: 'users');

  final String valueKey;

  const CollectionsEnum({required this.valueKey});
}
