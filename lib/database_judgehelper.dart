import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseJudgeHelper {
  static final DatabaseJudgeHelper _instance = DatabaseJudgeHelper._();

  static DatabaseJudgeHelper get instance => _instance;

  static Database? _database;

  DatabaseJudgeHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'judges.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS judges(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            contact TEXT
          )
        ''');
      },
    );
  }

  Future<int> addJudge(Map<String, dynamic> judge) async {
    final db = await database;
    return await db.insert('judges', judge);
  }

  Future<int> updateJudge(Map<String, dynamic> judge) async {
    final db = await database;
    final id = judge['id'];

    return await db.update(
      'judges',
      judge,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteJudge(int id) async {
    final db = await database;

    return await db.delete(
      'judges',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getJudges() async {
    final db = await database;
    return await db.query('judges');
  }
}
