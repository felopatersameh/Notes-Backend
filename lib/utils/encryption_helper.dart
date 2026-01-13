import 'package:bcrypt/bcrypt.dart';

class EncryptionHelper {
  /// Hash password (bcrypt)
  static String hashPassword(String password) {
    try {
      final salt = BCrypt.gensalt(logRounds: 12);
      return BCrypt.hashpw(password, salt);
    } catch (e) {
      throw Exception('Password hashing failed: $e');
    }
  }



  /// Verify password
  static bool verifyPassword(
    String plainPassword,
    String hashedPassword,
  ) {
    try {
      return BCrypt.checkpw(plainPassword, hashedPassword);
    } catch (e) {
      return false;
    }
  }
}
