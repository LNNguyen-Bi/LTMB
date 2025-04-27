import 'package:app_02/noteApp/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Lớp giúp quản lý cơ sở dữ liệu ghi chú
class NoteDatabaseHelper {
  static const _databaseName = "Notes.db"; // Tên cơ sở dữ liệu
  static const _databaseVersion = 1; // Phiên bản cơ sở dữ liệu
  static const table = 'notes'; // Tên bảng ghi chú

  // Singleton pattern
  NoteDatabaseHelper._privateConstructor();
  static final NoteDatabaseHelper instance = NoteDatabaseHelper._privateConstructor();

  static Database? _database; // Biến để lưu trữ cơ sở dữ liệu

  // Hàm để lấy cơ sở dữ liệu
  Future<Database> get database async => _database ??= await _initDatabase();

  // Hàm khởi tạo cơ sở dữ liệu
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName); // Đường dẫn đến cơ sở dữ liệu
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate); // Mở cơ sở dữ liệu
  }

  // Hàm tạo bảng ghi chú
  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        priority INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        modifiedAt TEXT NOT NULL,
        tags TEXT,
        color TEXT
      )
      ''');
  }

  // Hàm thêm ghi chú vào cơ sở dữ liệu
  Future<int> insertNote(Note note) async {
    Database db = await instance.database;
    return await db.insert(table, note.toMap()); // Chuyển đổi ghi chú thành Map và thêm vào bảng
  }

  // Hàm lấy tất cả ghi chú
  Future<List<Note>> getAllNotes() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table); // Truy vấn tất cả ghi chú
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]); // Chuyển đổi Map thành đối tượng Note
    });
  }

  // Hàm lấy ghi chú theo ID
  Future<Note?> getNoteById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Note.fromMap(result.first) : null; // Trả về ghi chú nếu tìm thấy
  }

  // Hàm cập nhật ghi chú
  Future<int> updateNote(Note note) async {
    Database db = await instance.database;
    return await db.update(table, note.toMap(), where: 'id = ?', whereArgs: [note.id]); // Cập nhật ghi chú
  }

  // Hàm xóa ghi chú
  Future<int> deleteNote(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]); // Xóa ghi chú theo ID
  }

  // Hàm lấy ghi chú theo mức độ ưu tiên
  Future<List<Note>> getNotesByPriority(int priority) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table, where: 'priority = ?', whereArgs: [priority]);
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]); // Chuyển đổi Map thành đối tượng Note
    });
  }

  // Hàm tìm kiếm ghi chú
  Future<List<Note>> searchNotes(String query) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table, where: 'title LIKE ? OR content LIKE ?', whereArgs: ['%$query%', '%$query%']);
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]); // Chuyển đổi Map thành đối tượng Note
    });
  }

  // Hàm sao lưu ghi chú
  Future<void> backupNotes() async {
    final notes = await getAllNotes();
    final jsonString = jsonEncode(notes.map((note) => note.toMap()).toList()); // Chuyển đổi danh sách ghi chú thành JSON

    final directory = await getApplicationDocumentsDirectory();
    final backupFile = File('${directory.path}/backup_notes.json');
    await backupFile.writeAsString(jsonString); // Ghi JSON vào file
  }

  // Hàm khôi phục ghi chú từ sao lưu
  Future<void> restoreNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupFile = File('${directory.path}/backup_notes.json');

    if (await backupFile.exists()) {
      final jsonString = await backupFile.readAsString();
      final List<dynamic> jsonList = jsonDecode(jsonString);

      for (var jsonNote in jsonList) {
        final note = Note.fromMap(jsonNote);
        await insertNote(note); // Thêm ghi chú vào cơ sở dữ liệu
      }
    }
  }
}