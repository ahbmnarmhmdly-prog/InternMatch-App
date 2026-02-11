import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'intern_app_v1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT,
            role TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE applications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            companyName TEXT,
            jobTitle TEXT,
            applicantName TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return results.isNotEmpty ? results.first : null;
  }

  
  Future<int> insertApplication(Map<String, dynamic> app) async {
    Database db = await database;
   
    return await db.insert('applications', app);
  }

  
  Future<List<Map<String, dynamic>>> getStudentApplications(String email) async {
    Database db = await database;
    return await db.query(
      'applications',
      where: 'applicantName = ?',
      whereArgs: [email],
      orderBy: 'id DESC', 
    );
  }

 
  Future<List<Map<String, dynamic>>> getCompanyApplications(String companyName) async {
    Database db = await database;
    return await db.query(
      'applications',
      where: 'companyName = ?',
      whereArgs: [companyName],
    );
  }

  
  Future<int> deleteApplication(int id) async {
    Database db = await database;
    return await db.delete(
      'applications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}