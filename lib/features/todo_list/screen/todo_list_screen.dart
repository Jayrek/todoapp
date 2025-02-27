import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Map<String, dynamic>? _userData;

  Future<void> getUserByDocID() async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    // if (userId == null) {
    //   print("No user signed in");
    //   return;
    // }

    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('user').doc(userId);

    try {
      DocumentSnapshot snapshot = await userDoc.get();

      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _userData = userData;
        });
        debugPrint("User found: ${userData['name']} - ${userData['email']}");
      } else {
        debugPrint("No user found with UID: $userId");
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchUsersStream() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final userId = auth.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('todo')
        .where('created_by', isEqualTo: userId)
        .orderBy('created_date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(),
        );
  }

  @override
  void initState() {
    super.initState();
    getUserByDocID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My ToDo List'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addTodo');
        },
        backgroundColor: Colors.black87,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      body: Column(
        children: [
          Text('Hi ${_userData?['name']}!'),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: fetchUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Your Todo LiSt is empty."));
                }

                List<Map<String, dynamic>> todos = snapshot.data!;

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    var todo = todos[index];
                    final isDone = todo['status'] == 0 ? true : false;
                    final timestamp = todo['created_date'];
                    final dateTime = timestamp.toDate();
                    final dateFormatted = DateFormat('MM/dd').format(dateTime);
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color:
                          isDone ? Colors.grey.shade500 : Colors.blue.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(todo['name'],
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none)),
                          subtitle: Text(todo['description'],
                              style: TextStyle(
                                  fontSize: 20,
                                  decoration: isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none)),
                          trailing: Text(isDone ? '' : dateFormatted,
                              style: const TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              )),
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
    );
  }
}
