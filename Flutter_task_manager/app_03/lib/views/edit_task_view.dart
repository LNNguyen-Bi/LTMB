import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';

class EditTaskView extends StatefulWidget {
  final Task task;

  EditTaskView({required this.task});

  @override
  _EditTaskViewState createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _status;
  int? _priority;
  DateTime? _dueDate;
  String? _assignedTo; // Thêm biến để lưu ID người được gán

  final TaskController _taskController = TaskController();
  final UserController _userController = UserController();
  List<User> users = []; // Danh sách người dùng

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _status = widget.task.status;
    _priority = widget.task.priority;
    _dueDate = widget.task.dueDate;
    _assignedTo = widget.task.assignedTo; // Khởi tạo với ID người được gán
    _loadUsers(); // Tải danh sách người dùng
  }

  Future<void> _loadUsers() async {
    users = await _userController.getUsers(); // Sử dụng getUsers
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _taskController.modifyTask(Task(
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text,
        status: _status!,
        priority: _priority!,
        dueDate: _dueDate,
        assignedTo: _assignedTo, // Cập nhật ID người dùng
        createdAt: widget.task.createdAt,
        updatedAt: DateTime.now(),
        createdBy: widget.task.createdBy,
        category: widget.task.category,
        attachments: widget.task.attachments,
        completed: widget.task.completed,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task'), backgroundColor: Colors.teal),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) => (value == null || value.isEmpty) ? 'Please enter title' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) => (value == null || value.isEmpty) ? 'Please enter description' : null,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: InputDecoration(labelText: 'Status'),
                    items: ['To do', 'In progress', 'Done', 'Cancelled']
                        .map((status) => DropdownMenuItem(
                      child: Text(status),
                      value: status,
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _status = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _priority,
                    decoration: InputDecoration(labelText: 'Priority'),
                    items: [
                      DropdownMenuItem(child: Text('Low'), value: 1),
                      DropdownMenuItem(child: Text('Medium'), value: 2),
                      DropdownMenuItem(child: Text('High'), value: 3),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _priority = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _assignedTo,
                    decoration: InputDecoration(labelText: 'Assigned To'),
                    items: users.map((user) {
                      return DropdownMenuItem(
                        child: Text(user.username),
                        value: user.id, // Sử dụng ID người dùng
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _assignedTo = value;
                        });
                      }
                    },
                  ),
                  Row(
                    children: [
                      Text(_dueDate == null
                          ? 'No due date chosen'
                          : 'Due Date: ${_dueDate!.toLocal().toString().split(' ')[0]}'),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dueDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 5),
                          );
                          if (picked != null) {
                            setState(() {
                              _dueDate = picked;
                            });
                          }
                        },
                        child: Text('Select Date'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Update Task'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Màu nút
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}