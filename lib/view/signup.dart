// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:new_todo/view/loginpage.dart';

// import 'userhomepage.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController customUidController = TextEditingController();

//   bool isLoading = false;

//   void _registerUser() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });

//       try {
//         // Create the user in Firebase Auth
//         UserCredential userCredential =
//             await _auth.createUserWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );

//         // Store the custom UID and user information in Firestore
//         String customUid = customUidController.text.trim();

//         await _firestore.collection('Users').doc(customUid).set({
//           'email': emailController.text.trim(),
//           'auth_uid': userCredential.user!.uid,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content:
//                 Text('Registration successful! Welcome to the Home Page 🎉'),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 3),
//           ),
//         );

//         // Navigate directly to the home page
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//       } on FirebaseAuthException catch (e) {
//         String message = 'An error occurred. Please try again.';
//         if (e.code == 'email-already-in-use') {
//           message = 'This email is already registered.';
//         } else if (e.code == 'weak-password') {
//           message = 'Password should be at least 6 characters.';
//         } else if (e.code == 'invalid-email') {
//           message = 'Invalid email format.';
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message), backgroundColor: Colors.red),
//         );
//       } finally {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: customUidController,
//                 decoration: InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Username.';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email.';
//                   } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Please enter a valid email address.';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password.';
//                   } else if (value.length < 6) {
//                     return 'Password must be at least 6 characters long.';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: _registerUser,
//                       child: Text('Sign Up'),
//                     ),
//               TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Loginpage(),
//                         ));
//                   },
//                   child: Text('if you have alredy an account  SignIn')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_todo/view/loginpage.dart';
import 'userhomepage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController customUidController = TextEditingController();

  bool isLoading = false;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );
      try {
        // Create the user in Firebase Auth
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Store the custom UID and user information in Firestore
        String customUid = customUidController.text.trim();

        await _firestore.collection('Users').doc(customUid).set({
          'email': emailController.text.trim(),
          'auth_uid': userCredential.user!.uid,
        });

        // Navigate directly to the Home Page

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Welcome 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred. Please try again.';
        if (e.code == 'email-already-in-use') {
          message = 'This email is already registered.';
        } else if (e.code == 'weak-password') {
          message = 'Password should be at least 6 characters.';
        } else if (e.code == 'invalid-email') {
          message = 'Invalid email format.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: customUidController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Username.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password.';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registerUser,
                      child: Text('Sign Up'),
                    ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Loginpage(),
                        ));
                  },
                  child: Text('If you have already an account, Sign In')),
            ],
          ),
        ),
      ),
    );
  }
}
