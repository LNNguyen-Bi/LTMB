class Task {
  String id;
  String title;
  String description;
  String status; // To do, In progress, Done, Cancelled
  int priority; // 1: Thấp, 2: Trung bình, 3: Cao
  DateTime? dueDate;
  DateTime createdAt;
  DateTime updatedAt;
  String? assignedTo; // ID người được giao
  String createdBy; // ID người tạo
  String? category; // Phân loại công việc
  List<String>? attachments; // Danh sách link tài liệu đính kèm
  bool completed; // Trạng thái hoàn thành

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    required this.createdBy,
    this.category,
    this.attachments,
    this.completed = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'To do',
      priority: json['priority'] ?? 1,
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) ?? DateTime.now() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now() : DateTime.now(),
      assignedTo: json['assignedTo'] != null && json['assignedTo'] is String ? json['assignedTo'] : null,
      createdBy: json['createdBy'] ?? '',
      category: json['category'] != null && json['category'] is String ? json['category'] : null,
      attachments: json['attachments'] != null
          ? List<String>.from((json['attachments'] as List).whereType<String>())
          : null,
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'assignedTo': assignedTo,
      'createdBy': createdBy,
      'category': category,
      'attachments': attachments,
      'completed': completed,
    };
  }
}