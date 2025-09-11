import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SQLiteStorageService {
  static Database? _database;
  static const String _databaseName = 'sanoc_storage.db';
  static const int _databaseVersion = 1;

  // Tables
  static const String _imagesTable = 'images';
  static const String _documentsTable = 'documents';
  static const String _userDataTable = 'user_data';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table pour les images
    await db.execute('''
      CREATE TABLE $_imagesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        filename TEXT NOT NULL,
        file_path TEXT NOT NULL,
        file_size INTEGER,
        mime_type TEXT,
        created_at TEXT NOT NULL,
        user_id TEXT
      )
    ''');

    // Table pour les documents
    await db.execute('''
      CREATE TABLE $_documentsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        filename TEXT NOT NULL,
        file_path TEXT NOT NULL,
        file_size INTEGER,
        mime_type TEXT,
        created_at TEXT NOT NULL,
        user_id TEXT,
        document_type TEXT
      )
    ''');

    // Table pour les données utilisateur
    await db.execute('''
      CREATE TABLE $_userDataTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL,
        value TEXT,
        user_id TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');
  }

  // Méthodes pour les images
  Future<int> saveImage(String filename, String filePath, String? userId) async {
    final db = await database;
    final file = File(filePath);
    final stat = await file.stat();
    
    return await db.insert(_imagesTable, {
      'filename': filename,
      'file_path': filePath,
      'file_size': stat.size,
      'mime_type': 'image/jpeg',
      'created_at': DateTime.now().toIso8601String(),
      'user_id': userId,
    });
  }

  Future<List<Map<String, dynamic>>> getImages(String? userId) async {
    final db = await database;
    if (userId != null) {
      return await db.query(_imagesTable, where: 'user_id = ?', whereArgs: [userId]);
    }
    return await db.query(_imagesTable);
  }

  Future<void> deleteImage(int id) async {
    final db = await database;
    final result = await db.query(_imagesTable, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      final filePath = result.first['file_path'] as String;
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      await db.delete(_imagesTable, where: 'id = ?', whereArgs: [id]);
    }
  }

  // Méthodes pour les documents
  Future<int> saveDocument(String filename, String filePath, String documentType, String? userId) async {
    final db = await database;
    final file = File(filePath);
    final stat = await file.stat();
    
    return await db.insert(_documentsTable, {
      'filename': filename,
      'file_path': filePath,
      'file_size': stat.size,
      'mime_type': 'application/pdf',
      'created_at': DateTime.now().toIso8601String(),
      'user_id': userId,
      'document_type': documentType,
    });
  }

  Future<List<Map<String, dynamic>>> getDocuments(String? userId) async {
    final db = await database;
    if (userId != null) {
      return await db.query(_documentsTable, where: 'user_id = ?', whereArgs: [userId]);
    }
    return await db.query(_documentsTable);
  }

  // Méthodes pour les données utilisateur
  Future<void> saveUserData(String key, String value, String? userId) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    await db.insert(_userDataTable, {
      'key': key,
      'value': value,
      'user_id': userId,
      'created_at': now,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getUserData(String key, String? userId) async {
    final db = await database;
    final result = await db.query(
      _userDataTable,
      where: 'key = ? AND user_id = ?',
      whereArgs: [key, userId],
    );
    
    if (result.isNotEmpty) {
      return result.first['value'] as String?;
    }
    return null;
  }

  // Nettoyage
  Future<void> clearUserData(String userId) async {
    final db = await database;
    await db.delete(_imagesTable, where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_documentsTable, where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(_userDataTable, where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
