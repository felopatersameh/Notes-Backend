import 'dart:convert';
import 'dart:typed_data';
import 'package:dotenv/dotenv.dart';
import 'package:pointycastle/export.dart';

class EncryptionHelper {
  static final env = DotEnv()..load();
  static final String _secretKey = env['SECRET_KEY_Encryption']!;

  static String encryptPassword(String password) {
    try {
      final key = _generateKey(_secretKey);
      final iv = Uint8List.fromList(List.filled(16, 0));

      final cipher = PaddedBlockCipherImpl(
        PKCS7Padding(),
        CBCBlockCipher(AESEngine()),
      )..init(
          true,
          PaddedBlockCipherParameters(
            ParametersWithIV(KeyParameter(key), iv),
            null,
          ),
        );

      final input = Uint8List.fromList(utf8.encode(password));
      final encrypted = cipher.process(input);

      return base64.encode(encrypted);
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  static String decryptPassword(String encryptedPassword) {
    try {
      final key = _generateKey(_secretKey);
      final iv = Uint8List.fromList(List.filled(16, 0));

      final cipher = PaddedBlockCipherImpl(
        PKCS7Padding(),
        CBCBlockCipher(AESEngine()),
      )..init(
          false,
          PaddedBlockCipherParameters(
            ParametersWithIV(KeyParameter(key), iv),
            null,
          ),
        );

      final encrypted = base64.decode(encryptedPassword);
      final decrypted = cipher.process(Uint8List.fromList(encrypted));

      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  static Uint8List _generateKey(String password) {
    final bytes = utf8.encode(password);
    if (bytes.length < 32) {
      // Pad to 32 bytes
      return Uint8List.fromList(
        bytes + List.filled(32 - bytes.length, 0),
      );
    }
    return Uint8List.fromList(bytes.sublist(0, 32));
  }
}
