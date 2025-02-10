import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_todo/view/signup.dart';
import 'package:new_todo/view/userhomepage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    label: Text('email'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    label: Text('Password'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  _signIn();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  elevation: 2, // Elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: Text('Sign In'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ));
                  },
                  child: Text("if don't have an account   SignUP"))
            ],
          ),
        ));
  }

//sign in function
  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sign in  Successfully')));

      if (User != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error :${e.toString()}'),
      ));
    }
  }

  //signUP
}
