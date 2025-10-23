import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/font_note.dart';

class DatabaseHelper {
  static const _databaseName = "FontNotes.db";
  static const _databaseVersion = 1;
  static const table = 'notes';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      usage TEXT NOT NULL,
      tags TEXT,
      date TEXT NOT NULL,
      isFavorite INTEGER NOT NULL DEFAULT 0
    )
  ''');
  }

  Future<int> insert(FontNote note) async {
    Database db = await instance.database;
    return await db.insert(table, note.toMap());
  }

  Future<List<FontNote>> getAllNotes() async {
    Database db = await instance.database;
    final maps = await db.query(table, orderBy: 'id DESC');
    return List.generate(maps.length, (i) => FontNote.fromMap(maps[i]));
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(FontNote note) async {
    Database db = await instance.database;
    return await db.update(
      table,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
