import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

Handler middleware(Handler handler) {
  return (context) async {
    // فتح DB
    final db = await Db.create(
      'mongodb+srv://notes:me4G12yUgdZTQfom@cluster1.oohzykz.mongodb.net/Notes?appName=Cluster1',
    );
    if (!db.isConnected) await db.open();

    // تمرير DB للـ handler
    final dbContext = handler.use(provider<Db>((_) => db));

    // تمرير auth middleware
    // final authContext = authMiddleware(dbContext);

    // نفذ request
    final response = await dbContext.call(context);

    return response;
  };
}

Handler authMiddleware(Handler handler) {
  return (context) async {
    final authHeader = context.request.headers['authorization'];

    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return Response(statusCode: 401, body: 'Unauthorized');
    }

    final token = authHeader.substring(7);

    try {
      final jwt = JWT.verify(token, SecretKey('secret_key_here'));

      // تمرير بيانات المستخدم
      final newHandler =
          handler.use(
        provider<Map<String, dynamic>>(
          (_) => jwt.payload as Map<String, dynamic>,
        ),
      );

      return await newHandler.call(context);
    } catch (e) {
      return Response(statusCode: 401, body: 'Token expired or invalid');
    }
  };
}



String generateToken(String userId, {bool withExpiry = true}) {
  final jwt = JWT(
    {
      'id': userId,
      'role': 'user', 
    },
  );

  if (withExpiry) {
    return jwt.sign(
      SecretKey('secret_key_here'),
      expiresIn: const Duration(hours: 1),
    );
  } else {
    return jwt.sign(SecretKey('secret_key_here'));
  }
}
