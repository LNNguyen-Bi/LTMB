import '../models/task.dart';
import '../services/task_service.dart';
import '../controllers/user_controller.dart';

class TaskController {
  final TaskService _taskService = TaskService();
  final UserController _userController = UserController();

  Future<List<Task>> fetchTasks({String? userId}) async {
    final loggedUser  = await _userController.getLoggedUser ();
    final tasks = await _taskService.getTasks();

    if (loggedUser ?.isAdmin == true) {
      // If the admin is logged in, return tasks based on the userId parameter
      if (userId != null) {
        return tasks.where((task) => task.assignedTo == userId).toList();
      }
      return tasks; // Admin can see all tasks
    } else {
      // Regular users can only see their own tasks
      return tasks.where((task) => task.assignedTo == loggedUser ?.id).toList();
    }
  }

  Future<void> createTask({
    required String title,
    required String description,
    required String status,
    required int priority,
    DateTime? dueDate,
    String? assignedTo,
    required String createdBy,
  }) {
    final now = DateTime.now();
    final task = Task(
      id: now.toIso8601String(),
      title: title,
      description: description,
      status: status,
      priority: priority,
      dueDate: dueDate,
      createdAt: now,
      updatedAt: now,
      assignedTo: assignedTo,
      createdBy: createdBy,
      completed: status.toLowerCase() == 'done',
    );
    return _taskService.addTask(task);
  }

  Future<void> modifyTask(Task task) {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
      assignedTo: task.assignedTo,
      createdBy: task.createdBy,
      completed: task.completed,
    );
    return _taskService.updateTask(updatedTask);
  }

  Future<void> removeTask(String id) {
    return _taskService.deleteTask(id);
  }
}