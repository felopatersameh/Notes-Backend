// ignore: lines_longer_than_80_chars
// ignore_for_file: eol_at_end_of_file, public_member_api_docs, prefer_final_fields, non_constant_identifier_names

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

class AuthData {
  const AuthData({
    required this.userId,
    required this.token,
  });

  final String userId;
  final String token;
}

class TokensClass {
  static final env = DotEnv()..load();
  static String _SecretKey = env['SECRET_KEY_Token']!;
  static final Set<String> _revokedTokens = {};

  static String generateToken(String userId, {bool withExpiry = true}) {
    final jwt = JWT(
      {
        'id': userId,
        'role': 'user',
      },
    );
    if (withExpiry) {
      return jwt.sign(
        SecretKey(_SecretKey),
        expiresIn: const Duration(days: 30),
      );
    } else {
      return jwt.sign(SecretKey(_SecretKey));
    }
  }

  static bool revokeToken(String token) {
    try {
      _revokedTokens.add(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isTokenRevoked(String token) {
    return _revokedTokens.contains(token);
  }

  static Handler authMiddleware(Handler handler) {
    return (context) async {
      final authHeader = context.request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'message': 'Unauthorized'},
        );
      }

      final token = authHeader.substring(7);

      if (isTokenRevoked(token)) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'message': 'Token has been revoked'},
        );
      }

      try {
        final jwt = JWT.verify(
          token,
          SecretKey(_SecretKey),
        );
        final map = jwt.payload as Map<String, dynamic>;
        final userId = map['id'] as String;

        final authData = AuthData(userId: userId, token: token);
        final authHandler = handler.use(provider<AuthData>((_) => authData));

        return authHandler.call(context);
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