import 'package:flutter/material.dart';
import 'package:app_02/noteApp/db/note_database_helper.dart';
import 'package:app_02/noteApp/models/note.dart';

// Màn hình biểu mẫu ghi chú
class NoteForm extends StatefulWidget {
  final Note? note; // Ghi chú (nếu có)

  const NoteForm({super.key, this.note});

  @override
  _NoteFormState createState() => _NoteFormState();
}

// Trạng thái của NoteForm
class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>(); // Khóa cho biểu mẫu
  final _titleController = TextEditingController(); // Controller cho tiêu đề
  final _contentController = TextEditingController(); // Controller cho nội dung
  int _priority = 1; // Mức độ ưu tiên mặc định
  List<String> _tags = []; // Danh sách thẻ
  String? _color; // Màu sắc ghi chú

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      // Nếu có ghi chú, điền thông tin vào các trường
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _priority = widget.note!.priority;
      _tags = widget.note!.tags ?? [];
      _color = widget.note!.color;
    }
  }

  @override
  void dispose() {
    _titleController.dispose(); // Giải phóng controller
    _contentController.dispose(); // Giải phóng controller
    super.dispose();
  }

  // Hàm lưu ghi chú
  void _saveNote() async {
    if (_formKey.currentState!.validate()) { // Kiểm tra tính hợp lệ của biểu mẫu
      final now = DateTime.now();
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        priority: _priority,
        createdAt: widget.note?.createdAt ?? now,
        modifiedAt: now,
        tags: _tags,
        color: _color,
      );

      if (widget.note == null) {
        await NoteDatabaseHelper.instance.insertNote(note); // Thêm ghi chú mới
      } else {
        await NoteDatabaseHelper.instance.updateNote(note); // Cập nhật ghi chú
      }
      Navigator.pop(context); // Quay lại màn hình trước
    }
  }

  // Hàm thêm thẻ
  void _addTag() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTag = ''; // Biến để lưu thẻ mới
        return AlertDialog(
          title: const Text('Add Tag'), // Tiêu đề hộp thoại
          content: TextField(
            onChanged: (value) {
              newTag = value; // Lưu thẻ mới
            },
            decoration: const InputDecoration(hintText: 'Enter tag name'), // Gợi ý nhập thẻ
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Cancel'), // Nút hủy
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tags.add(newTag); // Thêm thẻ mới vào danh sách
                });
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Add'), // Nút thêm
            ),
          ],
        );
      },
    );
  }

  // Hàm xóa thẻ
  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag); // Xóa thẻ khỏi danh sách
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'), // Tiêu đề màn hình
        actions: [
          IconButton(
            icon: const Icon(Icons.save), // Nút lưu
            onPressed: _saveNote, // Gọi hàm lưu ghi chú
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề ghi chú', // Nhãn cho trường tiêu đề
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title'; // Kiểm tra tính hợp lệ
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Content', // Nhãn cho trường nội dung
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content'; // Kiểm tra tính hợp lệ
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority', // Nhãn cho trường mức độ ưu tiên
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Thấp')),
                  DropdownMenuItem(value: 2, child: Text('Trung bình')),
                  DropdownMenuItem(value: 3, child: Text('Cao')),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!; // Cập nhật mức độ ưu tiên
                  });
                },
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 4.0,
                children: [
                  ElevatedButton(
                    onPressed: _addTag, // Gọi hàm thêm thẻ
                    child: const Text('Add Tag'), // Nút thêm thẻ
                  ),
                  ..._tags.map((tag) => Chip(
                    label: Text(tag), // Hiển thị thẻ
                    onDeleted: () => _removeTag(tag), // Gọi hàm xóa thẻ
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}