
import 'package:path/path.dart';
import 'package:sample_logins/models/users.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService{
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();
  final String _credTableName = "credentials";
  final String _credIdColumnName = "id";
  final String _credUsernameColumnName = "username";
  final String _credPasswordColumnName = "password";
  Future<Database> get database async{
    if(_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async{
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath,"master_db.db");
    final database = openDatabase(
      databasePath,
      version: 1,
      onCreate:
        (db, version) {
        db.execute('''
        CREATE TABLE $_credTableName(
          $_credIdColumnName INTEGER PRIMARY KEY,
          $_credUsernameColumnName TEXT NOT NULL,
          $_credPasswordColumnName TEXT NOT NULL
        )
        ''');
      },
    );
    return database;
  }
  void addUser(String username, String password) async {
    final db = await database;
    await db.insert(_credTableName, {
      _credUsernameColumnName : username,
      _credPasswordColumnName : password,
    });
  }
  Future<List<Users>?> getUsers() async{
    final db = await database;
    final data = await db.query(_credTableName);
    print(data);
  }
  void deleteUser(int id) async{
    final db = await database;
    await db.delete(_credTableName,
    where: 'id=?',
      whereArgs: [id,],
    );
  }
  Future<bool> authenticateUser(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(_credTableName,
        where: '${_credUsernameColumnName} = ? AND ${_credPasswordColumnName} = ?', whereArgs: [username, password]);

    return result.isNotEmpty; // Returns true if the user exists
  }
}