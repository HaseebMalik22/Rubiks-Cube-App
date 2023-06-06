import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TimeRecord {
  final int? id;  // Add a nullable type and default value
  final String participantName;
  final String round;
  final String attempt;
  final String time;

  TimeRecord({
    required this.id,
    required this.participantName,
    required this.round,
    required this.attempt,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantName': participantName,
      'round': round,
      'attempt': attempt,
      'time': time,
    };
  }
}

class TimeRecordHelper {
  static final String tableName = 'ParticipantTimeRecord';
  static final String columnId = 'id';
  static final String columnParticipantName = 'participantName';
  static final String columnRound = 'round';
  static final String columnAttempt = 'attempt';
  static final String columnTime = 'time';


  Future<Database> _database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'time_record_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName('
              '$columnId INTEGER PRIMARY KEY AUTOINCREMENT,'
              '$columnParticipantName TEXT,'
              '$columnRound TEXT,'
              '$columnAttempt TEXT,'
              '$columnTime TEXT'
              ')',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTimeRecord(TimeRecord timeRecord) async {
    final db = await _database();
    await db.insert(
      tableName,
      timeRecord.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TimeRecord>> getAllTimeRecords() async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return TimeRecord(
        id: maps[index][columnId],
        participantName: maps[index][columnParticipantName],
        round: maps[index][columnRound],
        attempt: maps[index][columnAttempt],
        time: maps[index][columnTime],
      );
    });
  }

  Future<void> updateTimeRecord(int id, String time) async {
    final db = await _database();
    await db.update(
      tableName,
      {columnTime: time},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }


}
