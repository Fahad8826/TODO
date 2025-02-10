import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:new_todo/view/Notification.dart';
import 'package:new_todo/view/loginpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDateTime;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _authenticateWithBiometrics();

    // Add biometric authentication on app start
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        bool authenticated = await _localAuth.authenticate(
          localizedReason: 'Use your fingerprint to unlock the app',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        if (!authenticated) {
          // Handle if authentication fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Biometric authentication failed.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Biometric authentication error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout'),
                    content: Text('Confirm Logout'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Loginpage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text('Logout')),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildClickableCard(
                    context,
                    LucideIcons.bell,
                    "Notifications",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Shedule_Notification()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableCard(
    BuildContext context,
    IconData iconData,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, size: 40, color: Colors.deepPurple),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
