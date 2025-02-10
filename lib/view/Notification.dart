
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/notification_sevice.dart';


class Shedule_Notification extends StatefulWidget {
  const Shedule_Notification({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Shedule_NotificationState createState() => _Shedule_NotificationState();
}

class _Shedule_NotificationState extends State<Shedule_Notification> {

  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDateTime;
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _notificationService.initNotification();

    _notificationService.initNotification();
    // Add biometric authentication on app start
  }

  Future<void> _selectDateTime() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _scheduleNotification() async {
    if (selectedDateTime == null || titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a date, time, and enter a title.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await _notificationService.scheduleNotification(
      id: notificationId,
      scheduledTime: selectedDateTime!,
      title: titleController.text,
    );

    // Save notification details to Firestore
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('notifications').add({
        'userId': user.uid,
        'title': titleController.text,
        'scheduledTime': selectedDateTime!.toIso8601String(),
        'notificationId': notificationId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification scheduled successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Reset fields
    setState(() {
      selectedDateTime = null;
      titleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shedule Notification'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Notification Title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      selectedDateTime == null
                          ? 'No Date Selected'
                          : 'Selected: ${DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _selectDateTime,
                      icon: Icon(Icons.calendar_today),
                      label: Text('Select Date and Time'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _scheduleNotification,
                      icon: Icon(Icons.notifications_active),
                      label: Text('Schedule Notification'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
