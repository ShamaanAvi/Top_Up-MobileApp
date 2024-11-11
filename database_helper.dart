import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        lastEdited TEXT NOT NULL
      )
    ''');
  }

  Future<int> addNote(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<List<Note>> fetchNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'lastEdited DESC');
    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> deleteNoteById(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteNotes(List<int> ids) async {
    final db = await instance.database;
    final idList = ids.map((id) => '?').join(', ');
    return await db.delete(
      'notes',
      where: 'id IN ($idList)',
      whereArgs: ids,
    );
  }
}

