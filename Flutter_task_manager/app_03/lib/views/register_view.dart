import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import 'login_view.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  final UserController _userController = UserController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _isAdmin = false;
  String? _avatarPath; // Biến để lưu đường dẫn ảnh đại diện

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera, // Chọn camera để chụp ảnh
    );
    if (image != null) {
      setState(() {
        _avatarPath = image.path; // Lưu đường dẫn ảnh
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _avatarPath = image.path; // Lưu đường dẫn ảnh
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(); // Gọi hàm chụp ảnh
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Chọn từ album'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery(); // Gọi hàm chọn từ album
              },
            ),
          ],
        );
      },
    );
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _passwordConfirmController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final success = await _userController.register(
      _usernameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      avatar: _avatarPath, // Gán đường dẫn ảnh đại diện
    );

    if (success) {
      setState(() {
        _isLoading = false;
        _successMessage = 'Registration successful! Please login.';
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Username or email already exists.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'), backgroundColor: Colors.teal),
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
                    GestureDetector(
                      onTap: _showImageSourceOptions, // Gọi hàm để chọn nguồn ảnh
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _avatarPath != null ? FileImage(File(_avatarPath!)) : null,
                        child: _avatarPath == null ? Icon(Icons.camera_alt, size: 50) : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (_errorMessage != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    if (_successMessage != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          _successMessage!,
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (val) => val == null || val.isEmpty ? 'Enter username' : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter email';
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}');
                        if (!emailRegex.hasMatch(val)) return 'Enter valid email';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (val) => val == null || val.isEmpty ? 'Enter password' : null,
                    ),
                    TextFormField(
                      controller: _passwordConfirmController,
                      decoration: InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (val) => val == null || val.isEmpty ? 'Confirm password' : null,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _isAdmin,
                          onChanged: (value) {
                            setState(() {
                              _isAdmin = value ?? false;
                            });
                          },
                        ),
                        Text('Register as Admin'),
                      ],
                    ),
                    SizedBox(height: 16),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _register,
                      child: Text('Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginView()));
                        },
                        child: Text('Already have an account? Login')),
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