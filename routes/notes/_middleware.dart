import 'package:dart_frog/dart_frog.dart';
import 'package:notes/utils/tokens.dart';

Handler middleware(Handler handler) {
  return TokensClass.authMiddleware(handler);
}
