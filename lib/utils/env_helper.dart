import 'dart:io';
import 'package:dotenv/dotenv.dart';

final env = EnvHelper();

class EnvHelper {
  factory EnvHelper() => _instance;
  EnvHelper._internal();
  // Singleton
  static final EnvHelper _instance = EnvHelper._internal();

  DotEnv? _env;

  void _loadEnv() {
    if (_env == null) {
      try {
        _env = DotEnv()..load();
        //print('💻 .env file loaded');
      } catch (e) {
        //print('⚠️ .env file not found or failed to load');
        _env = DotEnv(); // Empty instance
      }
    }
  }

  /// Get environment variable
  /// Priority: Platform.environment → .env file
  String? get(String key) {
    // Priority 1: Platform.environment (Railway/Production)
    final platformValue = Platform.environment[key];
    if (platformValue != null && platformValue.isNotEmpty) {
      //print('📡 Got $key from Platform.environment');
      return platformValue;
    }

    // Priority 2: .env file (Development)
    _loadEnv();
    final envValue = _env![key];
    if (envValue != null && envValue.isNotEmpty) {
      //print('💻 Got $key from .env file');
      return envValue;
    }

    // //print('❌ $key not found in environment');
    return null;
  }

  /// Get required - throw exception if not found
  String getRequired(String key) {
    final value = get(key);
    if (value == null || value.isEmpty) {
      throw Exception('❌ Required environment variable "$key" not found!');
    }
    return value;
  }

  /// Get with default value
  String getOrDefault(String key, String defaultValue) {
    return get(key) ?? defaultValue;
  }
}
