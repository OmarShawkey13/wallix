import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallix/core/models/wallpaper_model.dart';

class SqfliteHelper {
  static Database? _database;
  static const String tableName = 'favorites';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'wallix.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(urlImage TEXT PRIMARY KEY)',
        );
      },
    );
  }

  static Future<void> insertFavorite(WallpaperModel wallpaper) async {
    final db = await database;
    await db.insert(
      tableName,
      wallpaper.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteFavorite(String urlImage) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'urlImage = ?',
      whereArgs: [urlImage],
    );
  }

  static Future<List<WallpaperModel>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return WallpaperModel.fromDatabase(maps[i]);
    });
  }

  static Future<bool> isFavorite(String urlImage) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'urlImage = ?',
      whereArgs: [urlImage],
    );
    return maps.isNotEmpty;
  }
}
