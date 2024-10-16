import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _testDatabaseName = 'test.db';
  final String _tableTest = 'test_table';
  final String _testIdColumnName = 'id';
  final String _testNameColumnName = 'name';
  final String _testSurnameColumnName = 'surname';

  DatabaseService._constructor();
  
  Future<Database> get database async{
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!; 
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, _testDatabaseName);
    final database = await openDatabase(databasePath, version: 1,
      onOpen: (db) => logger.d("$_testDatabaseName opened at $databasePath"),
      onCreate:(db, version) {
        return db.execute('''
          CREATE TABLE IF NOT EXISTS $_tableTest (
            $_testIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $_testNameColumnName TEXT NOT NULL,
            $_testSurnameColumnName TEXT NOT NULL
          ) 
        '''
        );
      },
    );
    return database;
  }

  void addRegister(String name, String surname) async {
    final db = await database;
    await db.insert(
      _tableTest,
      {
        _testNameColumnName: name,
        _testSurnameColumnName: surname
      }
    );
  }

}