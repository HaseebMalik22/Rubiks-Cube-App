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
        ageGroup TEXT,
        roundNowOpen TEXT,
        attemptNowOpen TEXT
      )
    ''');
  }

  Future<void> updateRoundState(String roundName, String roundState) async {
    final db = await instance.database;
    await db.rawUpdate(
      'UPDATE rounds SET roundNowOpen = ? WHERE roundName = ?',
      [roundState, roundName],
    );
  }

  Future<void> updateAttemptState(String roundName, int attemptIndex) async {
    final db = await instance.database;
    final currentAttemptState = _getAttemptState(attemptIndex);
    await db.rawUpdate(
      'UPDATE rounds SET attemptNowOpen = ? WHERE roundName = ?',
      [currentAttemptState, roundName],
    );
  }


  String _getAttemptState(int attemptIndex) {
    switch (attemptIndex) {
      case 0:
        return 'attempt1';
      case 1:
        return 'attempt2';
      case 2:
        return 'attempt3';
      default:
        return 'none';
    }
  }

  Future<int> insertRound(Map<String, dynamic> round) async {
    final db = await instance.database;
    return await db.insert('rounds', round);
  }

  // Future<int> insertRound(Map<String, dynamic> round) async {
  //   final db = await instance.database;
  //   return await db.insert('rounds', round);
  // }

  Future<List<Map<String, dynamic>>> getRounds() async {
    final db = await instance.database;
    return await db.query('rounds');
  }

  Future<Map<String, dynamic>?> getRoundByName(String roundName) async {
    final db = await instance.database;
    List<Map<String, dynamic>> rounds = await db.query(
      'rounds',
      where: 'roundName = ?',
      whereArgs: [roundName],
    );
    if (rounds.isNotEmpty) {
      return rounds.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRoundData(String roundName) async {
    return await DatabaseRoundHelper.instance.getRoundByName(roundName);
  }


}
