import 'package:flutter/material.dart';
import 'package:app_02/noteApp/models/note.dart';

// Widget hiển thị một ghi chú
class NoteItem extends StatelessWidget {
  final Note note; // Ghi chú được truyền vào

  const NoteItem({super.key, required this.note});

  // Hàm lấy màu sắc dựa trên mức độ ưu tiên
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green; // Màu xanh cho mức độ ưu tiên thấp
      case 2:
        return Colors.yellow; // Màu vàng cho mức độ ưu tiên trung bình
      case 3:
        return Colors.red; // Màu đỏ cho mức độ ưu tiên cao
      default:
        return Colors.grey; // Màu xám cho mức độ ưu tiên không xác định
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getPriorityColor(note.priority).withOpacity(0.3), // Màu nền của thẻ
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Tiêu đề ghi chú
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // Nội dung ghi chú
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tạo: ${note.createdAt.toString().substring(0, 16)}', // Thời gian tạo
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cập nhật: ${note.modifiedAt.toString().substring(0, 16)}', // Thời gian sửa đổi
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
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
}