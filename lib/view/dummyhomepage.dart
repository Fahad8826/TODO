import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_todo/model/notification_sevice.dart';
import 'package:new_todo/view/TextSheduler.dart';
import 'package:new_todo/view/loginPage.dart';
import 'package:new_todo/view/userhomepage.dart';

class Dummyhomepage extends StatefulWidget {
  const Dummyhomepage({super.key});

  @override
  State<Dummyhomepage> createState() => _DummyhomepageState();
}

class _DummyhomepageState extends State<Dummyhomepage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService = NotificationService();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color sandColor =
        Color.fromARGB(255, 236, 212, 180); // Light sand color

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: sandColor,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.person, size: 30, color: Colors.brown),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Confirm Logout'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _auth.signOut();
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Loginpage()),
                                (route) => false,
                              );
                            }
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.brown,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: sandColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
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

            // Firestore Notifications List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _auth.currentUser == null
                    ? null
                    : _firestore
                        .collection('notifications')
                        .where('userId', isEqualTo: _auth.currentUser?.uid)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error loading notifications',
                          style: TextStyle(color: Colors.red)),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.notifications_none,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No tasks scheduled',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['title'].toString().toLowerCase();
                    final searchQuery = _searchController.text.toLowerCase();
                    return title.contains(searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final DateTime scheduledTime =
                          DateTime.parse(data['scheduledTime']);
                      final bool isPast =
                          scheduledTime.isBefore(DateTime.now());

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: isPast ? Colors.grey[100] : null,
                        child: ListTile(
                          title: Text(
                            data['title'],
                            style: TextStyle(
                                decoration:
                                    isPast ? TextDecoration.lineThrough : null),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMM dd, yyyy - HH:mm')
                                    .format(scheduledTime),
                                style: TextStyle(
                                    color:
                                        isPast ? Colors.grey : Colors.black54),
                              ),
                              if (isPast)
                                const Text(
                                  'Past due',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 160, 128, 87),
                                      fontSize: 12),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color.fromARGB(255, 160, 128, 87)),
                            onPressed: () =>
                                deleteTask(doc.id, data['notificationId']),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
           
          ],
        ),
      ),
    
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SheduleTask(),
              ));
        },
        backgroundColor: Colors.brown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
    );
  }

  Future<void> deleteTask(String docId, int notificationId) async {
    try {
      await _firestore.collection('notifications').doc(docId).delete();
      await _notificationService.cancelNotification(notificationId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Task deleted successfully'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to delete task: $e'),
            backgroundColor: Colors.red),
      );
    }
  }
}
