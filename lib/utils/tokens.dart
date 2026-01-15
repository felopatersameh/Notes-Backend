import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:notes/utils/env_helper.dart';
import 'package:uuid/uuid.dart';

class AuthData {
  const AuthData({
    required this.userId,
    required this.role,
    required this.token,
    required this.tokenId,
  });

  final String userId;
  final String role;
  final String token;
  final String tokenId;
}

class TokensClass {
  static final String _secretKey = env.getRequired('SECRET_KEY_Token');

  /// ⚠️ DEV ONLY
  static final Set<String> _revokedTokenIds = {};

  // ================== TOKEN ==================

  static String generateToken(
    String userId, {
    bool withExpiry = true,
    String? role,
  }) {
    final tokenId = const Uuid().v4();

    final jwt = JWT(
      {
        'sub': userId,
        'role': role ?? 'user',
        'jti': tokenId,
      },
    );

    return jwt.sign(
      SecretKey(_secretKey),
      expiresIn: withExpiry ? const Duration(days: 30) : null,
    );
  }

  static bool revokeToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_secretKey));
      final payload = jwt.payload as Map<String, dynamic>;
      _revokedTokenIds.add(payload['jti'].toString());
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool isTokenRevoked(String tokenId) {
    return _revokedTokenIds.contains(tokenId);
  }

  // ================== MIDDLEWARE ==================

  static Handler authMiddleware(Handler handler) {
    return (context) async {
      final header = context.request.headers['authorization'];

      if (header == null || !header.startsWith('Bearer ')) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'message': 'Unauthorized'},
        );
      }

      final token = header.substring(7);

      try {
        final jwt = JWT.verify(token, SecretKey(_secretKey));
        final payload = jwt.payload as Map<String, dynamic>;

        final tokenId = payload['jti'].toString();
        if (isTokenRevoked(tokenId)) {
          return Response.json(
            statusCode: HttpStatus.unauthorized,
            body: {'message': 'Token revoked'},
          );
        }

        final authData = AuthData(
          userId: payload['sub'].toString(),
          role: payload['role'].toString(),
          token: token,
          tokenId: tokenId,
        );

        return handler.use(provider<AuthData>((_) => authData)).call(context);
      } on JWTExpiredException {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'message': 'Token expired'},
        );
      } catch (_) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'message': 'Invalid token'},
        );
      }
    };
  }
}
