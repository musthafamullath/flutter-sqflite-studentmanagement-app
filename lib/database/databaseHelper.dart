import 'package:sqflite/sqflite.dart';

import '../model/students.dart';

class DatabaseHelper {
  static const _databaseVersion = 1;
  

  static const table = 'students';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';
  static const columnPlace = 'place';

  static const columnMobileNumber = 'mobileNumber';
  static const columnProfilePicture = 'profile_picture';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      'student.db',
      version: _databaseVersion,
      onCreate: _onCreate,

    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnAge INTEGER NOT NULL,
        $columnPlace TEXT NOT NULL,
        $columnMobileNumber INTEGER NOT NULL, 
        $columnProfilePicture TEXT NOT NULL,

      )
      ''');
  }

  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert(
      table,
      {
        columnName: student.name,
        columnAge: student.age,
        columnPlace: student.place,
        columnMobileNumber: student.mobileNumber,
        columnProfilePicture: student.profilePicturePath,
      },
    );
  }

  Future<List<Student>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(
      maps.length,
      (index) => Student(
        id: maps[index][columnId],
        name: maps[index][columnName],
        age: maps[index][columnAge],
        place: maps[index][columnPlace],
        mobileNumber: maps[index][columnMobileNumber],
        profilePicturePath: maps[index][columnProfilePicture], domain: null, 
      ),
    );
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      table,
      {
        columnName: student.name,
        columnAge: student.age,
        columnPlace: student.place,
        columnProfilePicture: student.profilePicturePath,
      },
      where: '$columnId = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
