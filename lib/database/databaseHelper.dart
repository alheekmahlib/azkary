import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../azkar/models/azkar.dart';


class DatabaseHelper {
  static Database? _db;
  static const int _version = 6;
  static const String tableAzkar = 'azkarTable';
  static const String columnDescription = 'description';
  static const String columnAId = 'id';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_db != null) return _db;
    // lazily instantiate the db the first time it is accessed
    // await initDatabase();
    _db = await initDb();
    return _db;
  }

  Future<Database?> initDb() async {
    sqfliteFfiInit();
    var androidDatabasesPath = await getDatabasesPath();
    var androidPath = p.join(androidDatabasesPath, 'notesBookmarks.db');
    Directory databasePath = await getApplicationDocumentsDirectory();
    var path = p.join(databasePath.path, 'notesBookmarks.db');
    return (Platform.isAndroid)
      ? openDatabase(androidPath,
        version: _version,
        readOnly: false,
        // onUpgrade: onUpgrade,
        onCreate: onCreate)
        : (Platform.isWindows || Platform.isLinux)
        ? databaseFactoryFfi.openDatabase(path,
        options: OpenDatabaseOptions(
            version: _version,
            readOnly: false,
            // onUpgrade: onUpgrade,
            onCreate: onCreate))
        : openDatabase(path,
        version: _version,
        readOnly: false,
        // onUpgrade: onUpgrade,
        onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE azkarTable ('
      'id INTEGER PRIMARY KEY, '
      'category TEXT, '
      'count TEXT, '
      'description TEXT, '
      'reference TEXT, '
      'zekr TEXT)',
    );
    print('create azkarTable');
  }

  Future onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Database onUpgrade');
    var results = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='bookmarkTextTable'");
    if (results.isEmpty) {
      await db.execute(
        'CREATE TABLE azkarTable ('
            'id INTEGER PRIMARY KEY, '
            'category TEXT, '
            'count TEXT, '
            'description TEXT, '
            'reference TEXT, '
            'zekr TEXT)',
      );
      print('Upgrade azkarTable');
    }
  }

  /// azkar database
  static Future<int?> addAzkar(Azkar? azkar) async {
    print('Save Azkar ${azkar!.id}');
    try {
      return await _db!.insert(tableAzkar, azkar!.toJson());
    } catch (e) {
      return 90000;
    }
  }

  static Future<int> deleteAzkar(Azkar? azkar) async {
    print('Delete Azkar');
    return await _db!
        .delete(tableAzkar, where: '$columnAId = ?', whereArgs: [azkar!.id]);
  }

  static Future<int> updateAzkar(Azkar azkar) async {
    print('Update Azkar');
    return await _db!.update(tableAzkar, azkar.toJson(),
        where: "$columnAId = ?", whereArgs: [azkar.id]);
  }

  static Future<List<Map<String, dynamic>>> queryC() async {
    print('Update Azkar');
    return await _db!.query(tableAzkar);
  }

  Future close() async {
    return await _db!.close();
  }
}
