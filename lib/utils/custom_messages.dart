class CustomMessages {
  static const String _methodsAllowed = 'Allowed methods: ';

  // Auth Messages
  static const String invalidEmailPassword = 'invalid email or password';
  static const String loginSuccess = 'Login Success';
  static const String registerFieldsRequired =
      'fields "name", "email", "password" are required';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Invalid email format';
  static const String passwordRequired = 'Password is required';
  static const String newPasswordRequired = 'New password is required';
  static const String passwordTooShort =
      'Password must be at least 6 characters';

  // User Messages
  static const String userNotFound = 'User not found';
  static const String userRetrievedSuccessfully = 'User retrieved successfully';
  static const String noDataProvidedForUpdate = 'No data provided for update';
  static const String failedToUpdateUser = 'Failed to update user';
  static const String userUpdatedSuccessfully = 'User updated successfully';
  static const String invalidDataFormat = 'Invalid data format';
  static const String failedToLogout = 'Failed to logout';
  static const String loggedOutSuccessfully = 'Logged out successfully';
  static const String failedToDeleteAccount = 'Failed to delete account';
  static const String accountDeletedSuccessfully =
      'Account deleted successfully';
  static const String oldPasswordIncorrect = 'Old password is incorrect';
  static const String passwordChangedSuccessfully =
      'Password changed successfully';

  // Notes Messages
  static const String notesRetrievedSuccessfully =
      'Notes retrieved successfully';
  static const String fieldBodyRequired = 'Field "body" is required';
  static const String failedToAddNote = 'Failed to add note';
  static const String noteAddedSuccessfully = 'Note added successfully';
  static const String noteRemovedSuccessfully = 'Note removed successfully';
  static const String noteNotFoundOrFailedToUpdate =
      'Note not found or failed to update';
  static const String noteUpdatedSuccessfully = 'Note updated successfully';
  static const String failedToClearNotes = 'Failed to clear notes';
  static const String allNotesClearedSuccessfully =
      'All notes cleared successfully';

  static String methodsAllowed({required List<MethodsEnum> methods}) {
    return '$_methodsAllowed${MethodsEnum.joinValues(methods)}';
  }
}

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
