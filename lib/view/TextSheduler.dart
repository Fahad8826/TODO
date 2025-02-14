import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../model/notification_sevice.dart';

class SheduleTask extends StatefulWidget {
  const SheduleTask({super.key});

  @override
  _SheduleTaskState createState() => _SheduleTaskState();
}

class _SheduleTaskState extends State<SheduleTask> {
  final TextEditingController titleController = TextEditingController();
  DateTime? selectedDateTime;
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  // Speech to text instance
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _notificationService.initNotification();
    initializeSpeech();
  }

  // Initialize speech recognition
  Future<void> initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (errorNotification) => print('Speech error: $errorNotification'),
    );
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Speech recognition not available on this device'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Toggle listening to speech
  void toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              titleController.text = result.recognizedWords;
              if (result.finalResult) {
                _isListening = false;
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> selectDateTime() async {
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

  Future<void> Shedule_Task() async {
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
          content: Text('Task scheduled successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() {
      selectedDateTime = null;
      titleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Task'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, color: Colors.brown),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Update UI when search input changes
                  },
                ),
              ),

              // Card(
              //   elevation: 4,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12)),
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       children: [
              //         Row(
              //           children: [
              //             Expanded(
              //               child: TextField(
              //                 controller: titleController,
              //                 decoration: InputDecoration(
              //                   labelText: 'Task Title',
              //                   border: OutlineInputBorder(),
              //                   prefixIcon: Icon(Icons.title),
              //                 ),
              //               ),
              //             ),
              //             SizedBox(width: 8),
              //             IconButton(
              //               onPressed: toggleListening,
              //               icon: Icon(
              //                 _isListening ? Icons.mic : Icons.mic_none,
              //                 color: _isListening ? Colors.red : Colors.grey,
              //               ),
              //               tooltip: 'Speak task title',
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 20),
              //         Text(
              //           selectedDateTime == null
              //               ? 'No Date Selected'
              //               : 'Selected: ${DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!)}',
              //           style: TextStyle(fontSize: 16),
              //         ),
              //         SizedBox(height: 20),
              //         ElevatedButton.icon(
              //           onPressed: selectDateTime,
              //           icon: Icon(Icons.calendar_today),
              //           label: Text('Select Date and Time'),
              //           style: ElevatedButton.styleFrom(
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(12)),
              //           ),
              //         ),
              //         SizedBox(height: 20),
              //         ElevatedButton.icon(
              //           onPressed: Shedule_Task,
              //           icon: Icon(Icons.notifications_active),
              //           label: Text('Schedule Task'),
              //           style: ElevatedButton.styleFrom(
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(12)),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
