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
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('user: $user');
    if (user != null) {
      final String userId = user.uid;

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('user').doc(userId);

      try {
        DocumentSnapshot snapshot = await userDoc.get();

        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;
          setState(() => _userData = userData);
        } else {
          debugPrint("no user found with UID: $userId");
        }
      } catch (e) {
        debugPrint("error fetching user: $e");
      }
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
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
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
          _buildHeaderAccountHeaderWidget(),
          const Divider(height: 1, indent: 20, endIndent: 20),
          const SizedBox(height: 10),
          _buildTodoListWidget(),
        ],
      ),
    );
  }

  Widget _buildHeaderAccountHeaderWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: _userData != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _userData!['photoUrl'] != null &&
                          _userData!['photoUrl'].toString().isNotEmpty
                      ? NetworkImage(_userData!['photoUrl'])
                      : null, // No image if empty
                  child: (_userData!['photoUrl'] == null ||
                          _userData!['photoUrl'].toString().isEmpty)
                      ? const Icon(Icons.person,
                          color: Colors.white) // Show icon when no image
                      : null,
                ),
                const SizedBox(width: 10),
                Text('Hi! ${_userData?['name']}!'),
              ],
            )
          : const SizedBox(),
    );
  }

  Widget _buildTodoListWidget() {
    return Expanded(
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: isDone ? Colors.grey.shade500 : Colors.blue.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _buildTodoItemWidget(
                      todoName: todo['name'],
                      todoDescription: todo['description'],
                      isDone: isDone,
                      dateFormatted: dateFormatted,
                      onTap: () {
                        debugPrint('fd');
                      }),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTodoItemWidget({
    required String todoName,
    required String todoDescription,
    required bool isDone,
    required String dateFormatted,
    required Function()? onTap,
  }) {
    return ListTile(
      title: Text(todoName,
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              decoration:
                  isDone ? TextDecoration.lineThrough : TextDecoration.none)),
      subtitle: Text(todoDescription,
          style: TextStyle(
              fontSize: 20,
              decoration:
                  isDone ? TextDecoration.lineThrough : TextDecoration.none)),
      trailing: Text(
        isDone ? '' : dateFormatted,
        style: const TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
