import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserController {
  final UserService _userService = UserService();
  final Uuid _uuid = Uuid();

  Future<bool> register(String username, String email, String password, {String? avatar, bool isAdmin = false}) async {
    final newUser  = User(
      id: _uuid.v4(),
      username: username,
      email: email,
      password: password,
      avatar: avatar, // Đảm bảo tham số này có mặt
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
      isAdmin: isAdmin,
    );
    return await _userService.register(newUser );
  }

  Future<User?> login(String usernameOrEmail, String password) {
    return _userService.login(usernameOrEmail, password);
  }

  Future<void> logout() {
    return _userService.logout();
  }

  Future<User?> getLoggedUser () {
    return _userService.getLoggedUser ();
  }

  Future<List<User>> getUsers() async {
    return await _userService.getUsers();
  }
}