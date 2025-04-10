import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('grades.db');
    return _database!;
  }

  // Open the database and create tables if they don't exist
  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, path);

    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE grades (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            student_name TEXT,
            father_name TEXT,
            department_name TEXT,
            shift TEXT,
            rollno TEXT,
            course_code TEXT,
            course_title TEXT,
            credit_hours TEXT,
            obtained_marks TEXT,
            semester TEXT,
            consider_status TEXT
          )
        ''');
      },
    );
  }

  // Insert data into the database
  Future<int> insertData(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('grades', row);
  }

  // Fetch data from the database
  Future<List<Map<String, dynamic>>> fetchData() async {
    final db = await instance.database;
    return await db.query('grades');
  }

  // Delete a specific row from the database by its ID
  Future<int> deleteRow(int id) async {
    final db = await instance.database;
    return await db.delete(
      'grades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Reset the database (delete all data)
  Future<void> resetDatabase() async {
    final db = await instance.database;
    await db.delete('grades'); // Delete all rows from the grades table
  }
}
