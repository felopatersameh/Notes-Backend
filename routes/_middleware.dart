import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:notes/env_helper.dart';
import 'package:notes/repositories/notes_repository.dart';
import 'package:notes/repositories/user_repository.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final mongoUri = env.getRequired('MONGO_URI');

    // Validate
    if (!mongoUri.startsWith('mongodb://') &&
        !mongoUri.startsWith('mongodb+srv://')) {
      throw Exception('Invalid MONGO_URI format');
    }
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
