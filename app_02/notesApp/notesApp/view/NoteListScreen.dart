import 'package:flutter/material.dart';
import '../db/NoteDatabaseHelper.dart';
import '../model/Note.dart';
import 'NoteItem.dart';
import 'NoteForm.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];
  List<Note> filteredNotes = []; // Danh sách ghi chú đã lọc
  final NoteDatabaseHelper _databaseHelper = NoteDatabaseHelper();
  String searchQuery = ''; // Biến để lưu trữ từ khóa tìm kiếm

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    List<Note> loadedNotes = await _databaseHelper.getAllNotes();
    setState(() {
      notes = loadedNotes;
      filteredNotes = loadedNotes; // Khởi tạo danh sách ghi chú đã lọc
    });
  }

  void _filterNotes(String query) {
    setState(() {
      searchQuery = query;
      filteredNotes = notes.where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _addNote() async {
    final newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteForm()),
    );
    if (newNote != null) {
      await _databaseHelper.insertNote(newNote);
      _loadNotes();
    }
  }

  void _deleteNote(int id) async {
    await _databaseHelper.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ghi chú của tôi'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadNotes,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterNotes,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm ghi chú...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: filteredNotes.isEmpty
          ? Center(child: Text('Không có ghi chú nào.'))
          : ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          return NoteItem(
            note: filteredNotes[index],
            onDelete: _deleteNote,
            onTap: () async {
              final updatedNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteForm(note: filteredNotes[index]),
                ),
              );
              if (updatedNote != null) {
                await _databaseHelper.updateNote(updatedNote);
                _loadNotes();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }
}