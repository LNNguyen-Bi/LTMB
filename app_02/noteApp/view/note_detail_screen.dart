import 'package:flutter/material.dart';
import 'package:app_02/noteApp/db/note_database_helper.dart';
import 'package:app_02/noteApp/models/note.dart';
import 'package:app_02/noteApp/view/note_form.dart';

// Màn hình chi tiết ghi chú
class NoteDetailScreen extends StatelessWidget {
  final Note note; // Ghi chú được truyền vào

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'), // Tiêu đề màn hình
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), // Nút chỉnh sửa
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteForm(note: note), // Chuyển đến màn hình chỉnh sửa
                ),
              ).then((value) => Navigator.pop(context, true));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete), // Nút xóa
            onPressed: () {
              _showDeleteConfirmationDialog(context); // Hiện hộp thoại xác nhận xóa
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Tiêu đề ghi chú
            ),
            const SizedBox(height: 16),
            Text(
              note.content,
              style: const TextStyle(fontSize: 16), // Nội dung ghi chú
            ),
            const SizedBox(height: 16),
            Text('Created: ${note.createdAt.toString().substring(0, 16)}'), // Thời gian tạo
            Text('Modified: ${note.modifiedAt.toString().substring(0, 16)}'), // Thời gian sửa đổi
            if (note.tags != null && note.tags!.isNotEmpty)
              Wrap(
                spacing: 4.0,
                children: note.tags!.map((tag) => Chip(label: Text(tag))).toList(), // Hiển thị thẻ
              ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị hộp thoại xác nhận xóa
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'), // Tiêu đề hộp thoại
          content: const Text('bạn chắc chắn muốn xóa note này?'), // Nội dung hộp thoại
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Cancel'), // Nút hủy
            ),
            TextButton(
              onPressed: () async {
                await NoteDatabaseHelper.instance.deleteNote(note.id!); // Xóa ghi chú
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.of(context).pop(true); // Quay lại màn hình trước
              },
              child: const Text('Delete'), // Nút xóa
            ),
          ],
        );
      },
    );
  }
}