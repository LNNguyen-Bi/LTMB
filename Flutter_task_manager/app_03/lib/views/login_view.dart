import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import 'register_view.dart';
import 'task_list_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserController _userController = UserController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final user = await _userController.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => TaskListView()));
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid username/email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), backgroundColor: Colors.teal),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username or Email'),
                      validator: (val) => val == null || val.isEmpty ? 'Enter username or email' : null,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val == null || val.isEmpty ? 'Enter password' : null,
                    ),
                    SizedBox(height: 16),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Màu nút
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterView()));
                        },
                        child: Text('Don\'t have an account? Register'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}