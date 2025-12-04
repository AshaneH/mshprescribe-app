import 'package:mshprescribe_app/models/bookmark.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mshprescribe.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            url TEXT,
            dateAdded TEXT
          )
        ''');
      },
    );
  }

  Future<int> addBookmark(Bookmark bookmark) async {
    final db = await database;
    return await db.insert('bookmarks', bookmark.toMap());
  }

  Future<List<Bookmark>> getBookmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookmarks',
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) => Bookmark.fromMap(maps[i]));
  }

  Future<int> removeBookmark(int id) async {
    final db = await database;
    return await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isBookmarked(String url) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookmarks',
      where: 'url = ?',
      whereArgs: [url],
    );
    return maps.isNotEmpty;
  }

  Future<void> removeBookmarkByUrl(String url) async {
    final db = await database;
    await db.delete('bookmarks', where: 'url = ?', whereArgs: [url]);
  }

  // Category URL Management
  Future<void> saveCategoryUrl(String category, String url) async {
    final db = await database;
    // Create table if not exists (handling migration simply here for now)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS category_links(
        category TEXT PRIMARY KEY,
        url TEXT
      )
    ''');

    await db.insert('category_links', {
      'category': category,
      'url': url,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getCategoryUrl(String category) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'category_links',
        where: 'category = ?',
        whereArgs: [category],
      );
      if (maps.isNotEmpty) {
        return maps.first['url'] as String;
      }
    } catch (e) {
      // Table might not exist yet
    }
    return null;
  }
}
