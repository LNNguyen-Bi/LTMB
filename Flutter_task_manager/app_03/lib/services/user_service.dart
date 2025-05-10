import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class UserService {
  static const _usersKey = 'users';
  static const _loggedUserIdKey = 'loggedUserId';

  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];
    final List<dynamic> usersList = json.decode(usersJson);
    return usersList.map((e) => User.fromJson(e)).toList();
  }

  Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonUsers = json.encode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_usersKey, jsonUsers);
  }

  Future<bool> register(User newUser) async {
    final users = await getUsers();
    if (users.any((u) => u.username == newUser.username || u.email == newUser.email)) {
      return false; // user or email already exists
    }
    users.add(newUser);
    await saveUsers(users);
    return true;
  }

  Future<User?> login(String usernameOrEmail, String password) async {
    final users = await getUsers();
    try {
      final user = users.firstWhere(
              (u) => (u.username == usernameOrEmail || u.email == usernameOrEmail) && u.password == password);
      await _setLoggedUserId(user.id);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedUserIdKey);
  }

  Future<String?> getLoggedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loggedUserIdKey);
  }

  Future<void> _setLoggedUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedUserIdKey, userId);
  }

  Future<User?> getLoggedUser() async {
    final userId = await getLoggedUserId();
    if (userId == null) return null;
    final users = await getUsers();
    try {
      return users.firstWhere((u) => u.id == userId);
    } catch (e) {
      return null;
    }
  }
}