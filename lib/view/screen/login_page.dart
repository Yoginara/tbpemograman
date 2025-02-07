import 'package:dio_contact/model/login_model.dart';
import 'package:dio_contact/services/api_services.dart';
import 'package:dio_contact/services/auth_manager.dart';
import 'package:dio_contact/view/bottom_navbar.dart';
import 'package:dio_contact/view/screen/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiServices _apiServices = ApiServices();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    bool success = await _apiServices.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Tidak lagi menggunakan res.status
      await AuthManager.login(_usernameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Berhasil!")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DynamicBottomNavbar()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Login Gagal. Periksa kembali kredensial Anda.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text("Login"),
                  ),
            const SizedBox(height: 10), // Beri jarak antar tombol
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text("Belum punya akun? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
