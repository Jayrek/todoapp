import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({
    required this.ownerId,
    super.key,
  });

  final String ownerId;

  Stream<List<Map<String, dynamic>>> fetchUsersStream() {
    return FirebaseFirestore.instance
        .collection('todo')
        .where('created_by', isEqualTo: ownerId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My ToDo List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black87,
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
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
    );
  }
}
