import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DBUtils{
  static Future init() async{
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'play_manager.db'),
      onCreate: (db, version){
        db.execute('CREATE TABLE play_items(id INTEGER PRIMARY KEY, date TEXT, playTime TEXT)');
      },
      version: 1,
    );
    return database;
  }
}