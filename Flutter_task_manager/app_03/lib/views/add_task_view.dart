import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';

class AddTaskView extends StatefulWidget {
  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = 'To do';
  int _priority = 2; // default medium
  DateTime? _dueDate;
  String? _assignedTo; // Variable to store assigned user ID

  final TaskController _taskController = TaskController();
  final UserController _userController = UserController();
  List<User> users = []; // List of users

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Load users
  }

  Future<void> _loadUsers() async {
    users = await _userController.getUsers(); // Fetch users
    setState(() {});
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? assignedTo;
      final loggedUser  = await _userController.getLoggedUser ();
      if (loggedUser ?.isAdmin == true) {
        assignedTo = _assignedTo; // Gán cho người dùng được chọn
      } else {
        assignedTo = loggedUser ?.id; // Gán cho chính họ
      }

      await _taskController.createTask(
        title: _titleController.text,
        description: _descriptionController.text,
        status: _status,
        priority: _priority,
        dueDate: _dueDate,
        createdBy: loggedUser ?.id ?? 'unknown', // ID người tạo
        assignedTo: assignedTo, // Pass the assigned user's ID
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
        backgroundColor: Colors.teal, // Màu nền app bar
      ),
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
                        value: user.id, // Use user ID
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _assignedTo = value; // Store selected user ID
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(_dueDate == null
                          ? 'No due date chosen'
                          : 'Due Date: ${_dueDate!.toLocal().toString().split(' ')[0]}'),
                      Spacer(),
                      TextButton(
                        onPressed: () => _selectDueDate(context),
                        child: Text('Select Date'),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Add Task'),
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