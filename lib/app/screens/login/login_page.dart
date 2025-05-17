import 'package:flutter/material.dart';
import 'package:remember_me/app/api/api_service.dart';
import 'package:remember_me/app/auth/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:remember_me/app/route/router_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(); // 회원가입용 이름 입력

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isLoginMode = true; // 로그인 / 회원가입 모드 토글

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _formKey.currentState?.reset();
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_isLoginMode) {
      // 로그인
      final result = await ApiService.I.signIn(email, password);

      result.fold(
        onSuccess: (token) async {
          AuthService.I.setTokens(token);
          if (mounted) {
            context.go(Routes.home);
          }
        },
        onFailure: (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message)));
        },
      );
    } else {
      // 회원가입
      final name = _nameController.text.trim();

      final result = await ApiService.I.signUp(email, password, name);

      result.fold(
        onSuccess: (token) async {
          AuthService.I.setTokens(token);
          if (mounted) {
            context.go(Routes.home);
          }
        },
        onFailure: (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message)));
        },
      );
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLoginMode ? "Login" : "Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              if (!_isLoginMode)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator:
                    (value) => value!.isEmpty ? 'Please enter email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (value) => value!.isEmpty ? 'Please enter password' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _submit,
                    child: Text(_isLoginMode ? 'Log In' : 'Sign Up'),
                  ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _toggleMode,
                child: Text(
                  _isLoginMode
                      ? "Don't have an account? Sign Up"
                      : "Already have an account? Log In",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
