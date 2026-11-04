import 'package:sqflite/sqflite.dart';

import 'student.dart';

class DatabaseHelper {
  static const _databaseName = 'students.db';
  static const _databaseVersion = 1;
  static const _tableName = 'students';
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }

    final path = '${await getDatabasesPath()}/$_databaseName';
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            regno TEXT NOT NULL,
            cgpa REAL NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  static Future<int> insertStudent(Student student) async {
    final database = await DatabaseHelper.database;
    return database.insert(_tableName, student.toMap());
  }

  static Future<List<Student>> getStudents() async {
    final database = await DatabaseHelper.database;
    final rows = await database.query(_tableName, orderBy: 'id DESC');
    return rows.map(Student.fromMap).toList();
  }
}
