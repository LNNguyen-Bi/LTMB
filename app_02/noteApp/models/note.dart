// Lớp đại diện cho một ghi chú
class Note {
  int? id; // ID của ghi chú
  String title; // Tiêu đề ghi chú
  String content; // Nội dung ghi chú
  int priority; // Mức độ ưu tiên
  DateTime createdAt; // Thời gian tạo
  DateTime modifiedAt; // Thời gian sửa đổi
  List<String>? tags; // Danh sách thẻ
  String? color; // Màu sắc ghi chú

  // Constructor
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    required this.modifiedAt,
    this.tags,
    this.color,
  });

  // Hàm khởi tạo từ Map
  Note.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        content = map['content'],
        priority = map['priority'],
        createdAt = DateTime.parse(map['createdAt']),
        modifiedAt = DateTime.parse(map['modifiedAt']),
        tags = map['tags']?.split(','), // Chuyển đổi chuỗi thẻ thành danh sách
        color = map['color'];

  // Hàm chuyển đổi ghi chú thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'tags': tags?.join(','), // Chuyển đổi danh sách thẻ thành chuỗi
      'color': color,
    };
  }

  // Hàm sao chép ghi chú với các thuộc tính mới
  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? priority,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? tags,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      tags: tags ?? this.tags,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, priority: $priority, createdAt: $createdAt, modifiedAt: $modifiedAt, tags: $tags, color: $color}';
  }
}