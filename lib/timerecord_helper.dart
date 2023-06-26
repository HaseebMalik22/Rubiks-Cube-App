import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TimeRecord {
  final int? id;
  final String participantName;
  final String round;
  final String attempt;
  String time; // Change to a regular field

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

  Future<List<TimeRecord>> getTimeRecordsForRound(String roundName) async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$columnRound = ?',
      whereArgs: [roundName],
    );
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

  Future<String?> getParticipantName(int participantID) async {
    final db = await _database();
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      columns: [columnParticipantName],
      where: '$columnId = ?',
      whereArgs: [participantID],
    );
    if (result.isNotEmpty) {
      return result.first[columnParticipantName];
    }
    return null;
  }


  Future<List<Map<String, dynamic>>> getParticipantTimes(String participantName) async {
    final db = await _database();
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      columns: [columnAttempt, columnTime],
      where: '$columnParticipantName LIKE ?', // Filter by participant name
      whereArgs: ['%$participantName%'], // Use wildcard for partial matching
    );

    return result;
  }


  // Future<List<String>> getRounds() async {
  //   final db = await _database();
  //   final List<Map<String, dynamic>> result = await db.rawQuery('''
  //     SELECT DISTINCT $columnRound
  //     FROM $tableName
  //   ''');
  //
  //   return result.map<String>((record) => record[columnRound]).toList();
  // }





  Future<String?> getAverageTimeForParticipant(String participantName) async {
    final db = await _database();
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT $columnTime
    FROM $tableName
    WHERE $columnParticipantName LIKE '%${participantName.toLowerCase()}%'
  ''');

    if (result.isNotEmpty) {
      List<int> minutesList = [];
      List<int> secondsList = [];
      List<int> millisecondsList = [];

      for (Map<String, dynamic> record in result) {
        final timeString = record[columnTime];
        final timeComponents = timeString.split(':');
        final minutes = int.parse(timeComponents[0]);
        final seconds = int.parse(timeComponents[1]);
        final milliseconds = int.parse(timeComponents[2]);

        minutesList.add(minutes);
        secondsList.add(seconds);
        millisecondsList.add(milliseconds);
      }

      if (minutesList.length > 2) {
        minutesList.sort();
        secondsList.sort();
        millisecondsList.sort();

        minutesList.removeAt(0); // Remove the lowest time
        minutesList.removeLast(); // Remove the highest time
        secondsList.removeAt(0);
        secondsList.removeLast();
        millisecondsList.removeAt(0);
        millisecondsList.removeLast();

        int averageMinutes = minutesList.reduce((a, b) => a + b) ~/ minutesList.length;
        int averageSeconds = secondsList.reduce((a, b) => a + b) ~/ secondsList.length;
        int averageMilliseconds = millisecondsList.reduce((a, b) => a + b) ~/ millisecondsList.length;

        return '${averageMinutes.toString().padLeft(2, '0')}:${averageSeconds.toString().padLeft(2, '0')}:${averageMilliseconds.toString().padLeft(3, '0')}';
      }
    }
    return null;
  }





  Future<void> updateTimeRecord(int? id, String time) async {
    final db = await _database();
    await db.update(
      tableName,
      {columnTime: time},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
