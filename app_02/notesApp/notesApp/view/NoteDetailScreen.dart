import 'package:flutter/material.dart';
import '../model/Note.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  NoteDetailScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nội dung:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(note.content),
            SizedBox(height: 16),
            Text('Thời gian tạo: ${note.createdAt}'),
            Text('Thời gian cập nhật: ${note.modifiedAt}'),
            SizedBox(height: 16),
            Text('Nhãn: ${note.tags?.join(', ') ?? 'Không có'}'),
          ],
        ),
      ),
    );
  }
}