enum KeysEnum {
  /// Public Keys
  data(valueKey: 'data'),
  message(valueKey: 'message'),
  token(valueKey: 'token'),
  id(valueKey: '_id'),
  role(valueKey: 'role'),

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
