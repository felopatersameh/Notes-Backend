// ignore_for_file: public_member_api_docs, sort_constructors_first

enum KeysEnum {
  /// Public Keys
  data(valueKey: 'data'),
  message(valueKey: 'message'),
  token(valueKey: 'token'),
  id(valueKey: '_id'),

  /// User && notes Keys
  email(valueKey: 'email'),
  name(valueKey: 'name'),
  password(valueKey: 'password'),
  newPassword(valueKey: 'newPassword'),
  notes(valueKey: 'notes'),
  createAt(valueKey: 'createAt'),
  idNotes(valueKey: 'id_note'),
  subject(valueKey: 'subject'),
  body(valueKey: 'body'),
  updateAt(valueKey: 'updateAt');

  final String valueKey;

  const KeysEnum({required this.valueKey});
}
