import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRoundHelper {
  static final DatabaseRoundHelper instance = DatabaseRoundHelper._getInstance();

  static Database? _database;

  DatabaseRoundHelper._getInstance();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'rounds.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rounds(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        matchName TEXT,
        roundName TEXT,
        participant TEXT,
        judge TEXT,
        previousQualified TEXT,
        ageGroup TEXT
      )
    ''');
  }

  // Future<int> deleteAllRounds() async {
  //   final db = await instance.database;
  //   return await db.delete('rounds');
  // }

  Future<int> insertRound(Map<String, dynamic> round) async {
    final db = await instance.database;
    return await db.insert('rounds', round);
  }

  Future<List<Map<String, dynamic>>> getRounds() async {
    final db = await instance.database;
    return await db.query('rounds');
  }
}
