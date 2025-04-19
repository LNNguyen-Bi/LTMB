import 'dart:convert';

class Note {
  int? id;
  String title;
  String content;
  DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  factory Note.fromJSON(String source) {
    return Note.fromMap(jsonDecode(source));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJSON() {
    return jsonEncode(toMap());
  }
}