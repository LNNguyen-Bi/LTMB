import 'package:flutter/material.dart';
import 'package:app_02/noteApp/db/note_database_helper.dart';
import 'package:app_02/noteApp/models/note.dart';
import 'package:app_02/noteApp/view/note_detail_screen.dart';
import 'package:app_02/noteApp/view/note_form.dart';
import 'package:app_02/noteApp/view/note_item.dart';

// Màn hình danh sách ghi chú
class NoteListScreen extends StatefulWidget {
  final Function toggleTheme; // Hàm để chuyển đổi theme

  const NoteListScreen({super.key, required this.toggleTheme});

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

// Trạng thái của NoteListScreen
class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> _notes = []; // Danh sách ghi chú
  bool _isGrid = false; // Biến để xác định chế độ hiển thị (danh sách hoặc lưới)
  int _filterPriority = 0; // Bộ lọc mức độ ưu tiên
  String _searchQuery = ''; // Chuỗi tìm kiếm

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Tải ghi chú khi khởi tạo
  }

  // Hàm tải ghi chú
  Future<void> _loadNotes() async {
    List<Note> notes;
    if (_searchQuery.isNotEmpty) {
      notes = await NoteDatabaseHelper.instance.searchNotes(_searchQuery); // Tìm kiếm ghi chú
    } else if (_filterPriority > 0) {
      notes = await NoteDatabaseHelper.instance.getNotesByPriority(_filterPriority); // Lọc ghi chú theo mức độ ưu tiên
    } else {
      notes = await NoteDatabaseHelper.instance.getAllNotes(); // Lấy tất cả ghi chú
    }
    setState(() {
      _notes = notes; // Cập nhật danh sách ghi chú
    });
  }

  // Hàm thêm ghi chú
  void _addNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteForm()), // Chuyển đến màn hình thêm ghi chú
    );
    _loadNotes(); // Tải lại ghi chú
  }

  // Hàm làm mới ghi chú
  void _refreshNotes() {
    _loadNotes(); // Tải lại ghi chú
  }

  // Hàm chuyển đổi giữa chế độ danh sách và lưới
  void _toggleView() {
    setState(() {
      _isGrid = !_isGrid; // Đảo ngược chế độ hiển thị
    });
  }

  // Hàm lọc ghi chú theo mức độ ưu tiên
  void _filterByPriority(int priority) {
    setState(() {
      _filterPriority = priority; // Cập nhật bộ lọc mức độ ưu tiên
    });
    _loadNotes(); // Tải lại ghi chú
  }

  // Hàm tìm kiếm ghi chú
  void _searchNotes(String query) {
    setState(() {
      _searchQuery = query; // Cập nhật chuỗi tìm kiếm
    });
    _loadNotes(); // Tải lại ghi chú
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'), // Tiêu đề màn hình
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Nút làm mới
            onPressed: _refreshNotes, // Gọi hàm làm mới ghi chú
          ),
          IconButton(
            icon: Icon(_isGrid ? Icons.list : Icons.grid_view), // Nút chuyển đổi chế độ hiển thị
            onPressed: _toggleView, // Gọi hàm chuyển đổi chế độ
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6), // Nút chuyển đổi theme
            onPressed: () {
              widget.toggleTheme(); // Gọi hàm chuyển đổi theme
            },
          ),
          IconButton(
            icon: const Icon(Icons.save), // Nút sao lưu
            onPressed: () async {
              await NoteDatabaseHelper.instance.backupNotes(); // Sao lưu ghi chú
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ghi chú đã được sao lưu!')), // Thông báo sao lưu thành công
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.restore), // Nút khôi phục
            onPressed: () async {
              await NoteDatabaseHelper.instance.restoreNotes(); // Khôi phục ghi chú
              _loadNotes(); // Tải lại ghi chú
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ghi chú đã được khôi phục!')), // Thông báo khôi phục thành công
              );
            },
          ),
          PopupMenuButton<int>(
            onSelected: _filterByPriority, // Gọi hàm lọc theo mức độ ưu tiên
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Tất cả mức độ ưu tiên'), // Tùy chọn tất cả
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Mức độ ưu tiên thấp'), // Tùy chọn mức độ ưu tiên thấp
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Mức độ ưu tiên trung bình'), // Tùy chọn mức độ ưu tiên trung bình
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text('Mức độ ưu tiên cao'), // Tùy chọn mức độ ưu tiên cao
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm ghi chú...', // Gợi ý tìm kiếm
                prefixIcon: Icon(Icons.search), // Biểu tượng tìm kiếm
                border: OutlineInputBorder(),
              ),
              onChanged: _searchNotes, // Gọi hàm tìm kiếm
            ),
          ),
        ),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('Hiện chưa có ghi chú nào.')) // Thông báo nếu không có ghi chú
          : _isGrid
          ? GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số cột trong chế độ lưới
          childAspectRatio: 0.8,
        ),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(note: _notes[index]), // Chuyển đến màn hình chi tiết ghi chú
                ),
              ).then((value) => _loadNotes()); // Tải lại ghi chú sau khi quay lại
            },
            child: NoteItem(note: _notes[index]), // Hiển thị ghi chú
          );
        },
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(note: _notes[index]), // Chuyển đến màn hình chi tiết ghi chú
                ),
              ).then((value) => _loadNotes()); // Tải lại ghi chú sau khi quay lại
            },
            child: NoteItem(note: _notes[index]), // Hiển thị ghi chú
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote, // Gọi hàm thêm ghi chú
        child: const Icon(Icons.add), // Biểu tượng thêm
      ),
    );
  }
}