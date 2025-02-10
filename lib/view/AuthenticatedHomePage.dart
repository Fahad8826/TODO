import 'package:flutter/material.dart';
import 'package:new_todo/model/Authentication_service.dart';
import 'package:new_todo/view/userhomepage.dart';



class LoginScreen extends StatelessWidget {
  final AuthService authService;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen(this.authService);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                await authService.login(emailController.text.trim(),
                    passwordController.text.trim());
                bool authenticated =
                    await authService.authenticateWithBiometrics();
                if (authenticated) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Biometric authentication failed')),
                  );
                }
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
