import 'package:flutter/material.dart';
import '../db/NoteDatabaseHelper.dart';
import '../model/Note.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class NoteForm extends StatefulWidget {
  final Note? note;

  NoteForm({this.note});

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late int _priority;
  late String? _color;
  List<String> _tags = [];
  Color _selectedColor = Colors.white;


  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
      _priority = widget.note!.priority;
      _color = widget.note!.color;
      _tags = widget.note!.tags ?? [];
      if (_color != null) {
        _selectedColor = Color(int.parse(_color!, radix: 16));
      }
    } else {
      _title = '';
      _content = '';
      _priority = 6; // Mặc định là ưu tiên thấp
      _color = null;
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final note = Note(
        id: widget.note?.id,
        title: _title,
        content: _content,
        priority: _priority,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        modifiedAt: DateTime.now(),
        tags: _tags,
        color: _selectedColor.value.toRadixString(16),
      );
      Navigator.pop(context, note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Thêm Ghi Chú' : 'Sửa Ghi Chú'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _content,
                decoration: InputDecoration(labelText: 'Nội dung'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
                maxLines: null, // Cho phép nội dung kéo dài xuống nhiều dòng
                minLines: 3, // Bắt đầu với ít nhất 3 dòng hiển thị
              ),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Mức độ ưu tiên'),
                items: [
                  DropdownMenuItem(value: 6, child: Text('note ưu tiên thấp')),
                  DropdownMenuItem(value: 2, child: Text('note ưu tiên trung bình')),
                  DropdownMenuItem(value: 3, child: Text('note ưu tiên cao')),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Chọn Màu'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: _selectedColor,
                            onColorChanged: (color) => setState(() => _selectedColor = color),
                            enableAlpha: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Chọn'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Chọn Màu'),
              ),
              SizedBox(height: 16),

              Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  shape: BoxShape.circle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}