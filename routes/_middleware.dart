import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/repositories/user_repository.dart';

Handler middleware(Handler handler) {
  return (context) async {
          final env = DotEnv()..load();
      final mongoUri = env['MONGO_URI'] ?? '';
    final db = await Db.create(
      mongoUri,
    );
    if (!db.isConnected) await db.open();

    final dbContext = handler
        .use(provider<Db>((_) => db))
        .use(
          provider<UserRepository>(
            (_) => UserRepository(db),
          ),
        )
        .use(
          provider<NotesRepository>(
            (_) => NotesRepository(db),
          ),
        );

    // final authContext = authMiddleware(dbContext);

    final response = await dbContext.call(context);

    return response;
  };
}
