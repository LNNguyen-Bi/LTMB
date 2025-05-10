import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../controllers/user_controller.dart';
import '../models/task.dart';
import '../models/user.dart'; // Import the User model
import 'add_task_view.dart';
import 'edit_task_view.dart';
import 'login_view.dart';
import 'dart:io';

class TaskListView extends StatefulWidget {
  const TaskListView({Key? key}) : super(key: key);

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final TaskController _taskController = TaskController();
  final UserController _userController = UserController();
  late Future<List<Task>> _tasks;
  String _searchQuery = '';
  String _selectedStatus = 'All';
  List<String> _statuses = ['All', 'To do', 'In progress', 'Done', 'Cancelled'];
  bool _isListView = true;
  List<User> users = []; // List to hold users
  User? _loggedUser ; // Variable to hold logged-in user
  String? _selectedUserId; // Variable to hold the selected user ID

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadUsers(); // Load users when the view is initialized
    _getLoggedUser (); // Get logged-in user information
  }

  void _loadTasks() {
    setState(() {
      _tasks = _taskController.fetchTasks(userId: _selectedUserId); // Pass selected user ID
    });
  }

  void _loadUsers() async {
    users = await _userController.getUsers(); // Fetch users
    print("Loaded users: ${users.length}"); // In ra số lượng người dùng đã tải
    for (var user in users) {
      print("User  ID: ${user.id}, Username: ${user.username}, Email: ${user.email}"); // In ra thông tin người dùng
    }
  }

  void _getLoggedUser () async {
    _loggedUser  = await _userController.getLoggedUser (); // Get logged-in user information
  }

  void _logout() async {
    await _userController.logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginView()));
  }

  Future<List<Task>> _filterTasks(List<Task> tasks) async {
    final loggedUser  = await _userController.getLoggedUser ();
    return tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'All' || task.status == _selectedStatus;
      final matchesAssignedTo = loggedUser ?.isAdmin == true || task.assignedTo == loggedUser ?.id;
      return matchesSearch && matchesStatus && matchesAssignedTo;
    }).toList();
  }

  String _getUsernameById(String? userId) {
    final user = users.firstWhere(
          (User  user) => user.id == userId,
      orElse: () => User(
        id: '', // Default ID
        username: "Unassigned", // Default username
        password: '', // Default password (not used)
        email: '', // Default email (not used)
        avatar: null, // Default avatar (not used)
        createdAt: DateTime.now(), // Default createdAt
        lastActive: DateTime.now(), // Default lastActive
        isAdmin: false, // Default isAdmin
      ),
    );
    return user.username; // Return the username
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Colors.teal,
        actions: [
          // Display avatar on the right side of the app bar
          CircleAvatar(
            backgroundImage: _loggedUser ?.avatar != null ? FileImage(File(_loggedUser !.avatar!)) : null,
            child: _loggedUser ?.avatar == null ? Icon(Icons.person) : null,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
          IconButton(
            icon: Icon(_isListView ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                _isListView = !_isListView;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh), // Refresh button
            onPressed: () {
              _loadTasks(); // Call to reload the task list
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_loggedUser ?.isAdmin == true) // Show user selection for admin
            DropdownButton<String>(
              value: _selectedUserId,
              hint: Text('Select User'),
              items: users.map((user) {
                return DropdownMenuItem<String>(
                  value: user.id,
                  child: Text(user.username),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUserId = newValue; // Update selected user ID
                  _loadTasks(); // Reload tasks based on selected user
                });
              },
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          DropdownButton<String>(
            value: _selectedStatus,
            items: _statuses.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue!;
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _tasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tasks available.'));
                }

                // Get the list of tasks from the snapshot
                final tasks = snapshot.data!;
                print("Loaded tasks: ${tasks.length}"); // In ra số lượng công việc đã tải
                for (var task in tasks) {
                  print("Task ID: ${task.id}, Title: ${task.title}, Assigned To: ${task.assignedTo}, Status: ${task.status}"); // In ra thông tin công việc
                }

                // Filter tasks based on user permissions
                return FutureBuilder<List<Task>>(
                  future: _filterTasks(tasks), // Await the filtering of tasks
                  builder: (context, filterSnapshot) {
                    if (filterSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (filterSnapshot.hasError) {
                      return Center(child: Text('Error: ${filterSnapshot.error}'));
                    } else if (!filterSnapshot.hasData || filterSnapshot.data!.isEmpty) {
                      return const Center(child: Text('No tasks available.'));
                    }

                    final filteredTasks = filterSnapshot.data!; // Get the filtered tasks
                    return _isListView ? _buildListView(filteredTasks) : _buildKanbanBoard(filteredTasks);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskView()),
          ).then((_) => _loadTasks());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildListView(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.description),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStatusBadge(task.status),
                    const SizedBox(width: 10),
                    Text('Priority: ${_priorityText(task.priority)}'),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text('Assigned To: ${_getUsernameById(task.assignedTo)}'),
                  ],
                ),
                if (task.dueDate != null)
                  Text('Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}'),
              ],
            ),
            trailing: Checkbox(
              value: task.completed,
              onChanged: (bool? value) {
                setState(() {
                  task.completed = value ?? false;
                  task.status = task.completed ? 'Done' : 'To do';
                  _taskController.modifyTask(task);
                });
              },
            ),
            onLongPress: () async {
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Delete Task'),
                    content: Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                await _taskController.removeTask(task.id);
                _loadTasks();
              }
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditTaskView(task: task)),
              ).then((_) => _loadTasks());
            },
          ),
        );
      },
    );
  }

  Widget _buildKanbanBoard(List<Task> tasks) {
    Map<String, List<Task>> categorizedTasks = {
      'To do': [],
      'In progress': [],
      'Done': [],
      'Cancelled': [],
    };

    for (var task in tasks) {
      categorizedTasks[task.status]?.add(task);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categorizedTasks.entries.map((entry) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                ...entry.value.map((task) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      onLongPress: () async {
                        final confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete Task'),
                              content: Text('Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete == true) {
                          await _taskController.removeTask(task.id);
                          _loadTasks();
                        }
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'to do':
        color = Colors.grey;
        break;
      case 'in progress':
        color = Colors.blue;
        break;
      case 'done':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.black45;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _priorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Unknown';
    }
  }
}