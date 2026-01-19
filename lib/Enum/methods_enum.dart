enum MethodsEnum {
  put('Put'),
  get('Get'),
  post('Post'),
  delete('Delete');

  final String valueString;
  const MethodsEnum(this.valueString);

  static String joinValues(List<MethodsEnum> methods) {
    return methods.map((e) => e.valueString).join('/');
  }
}
