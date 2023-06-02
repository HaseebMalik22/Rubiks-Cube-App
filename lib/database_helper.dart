import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();

  static DatabaseHelper get instance => _instance;

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'participants.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE participants(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            contact TEXT,
            dateOfBirth TEXT,
            category TEXT,
            time TEXT
          )
        ''');
      },
    );
  }

  Future<int> addParticipant(Map<String, dynamic> participant) async {
    final db = await database;
    return await db.insert('participants', participant);
  }

  Future<int> updateParticipant(Map<String, dynamic> participant) async {
    final db = await database;
    final id = participant['id'];

    return await db.update(
      'participants',
      participant,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteParticipant(int id) async {
    final db = await database;

    return await db.delete(
      'participants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getParticipantByName(String participantName) async {
    final db = await database;
    final result = await db.query(
      'participants',
      where: 'name = ?',
      whereArgs: [participantName],
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }
}
