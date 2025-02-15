import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytodolist/shared/widgets/custom_elevated_button_widget.dart';
import 'package:mytodolist/shared/widgets/custom_textformfield_widget.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _todoNameController = TextEditingController();
  final _todoDescriptionController = TextEditingController();

  bool isAddingTodo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeW ToDo'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A task ToDo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -2,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          'Adding your task to your ToDo',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomTextFormFieldWidget(
                  icon: Icons.note,
                  controller: _todoNameController,
                  hintText: 'What to do?',
                  labelText: 'Todo Name',
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter task name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormFieldWidget(
                  icon: Icons.note,
                  controller: _todoDescriptionController,
                  hintText: 'Description',
                  labelText: 'Description',
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter task description';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButtonWidget(
                          backgroundColor: Colors.black87,
                          childWidget: isAddingTodo
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'ADD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await addTodo(
                                name: _todoNameController.text,
                                description: _todoDescriptionController.text,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addTodo({
    required String name,
    required String description,
  }) async {
    setState(() => isAddingTodo = true);

    FirebaseAuth auth = FirebaseAuth.instance;
    final userId = auth.currentUser?.uid;

    CollectionReference todo = FirebaseFirestore.instance.collection('todo');

    try {
      await todo.add({
        'id': todo.doc().id,
        'created_by': userId,
        'description': description,
        'name': name,
        'image': '',
        'status': 1,
        'created_date': Timestamp.now(),
        'updated_date': Timestamp.now(),
      });
      await Future.delayed(const Duration(seconds: 3), () {
        setState(() => isAddingTodo = false);

        if (!mounted) return;
        Navigator.of(context).pop();
      });
    } on FirebaseException catch (e) {
      setState(() => isAddingTodo = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }
}

// // update the todo to DONE
// Future<void> updateTodoStatus(String todoId) async {
//   CollectionReference todo = FirebaseFirestore.instance.collection('todo');

//   try {
//     await todo.doc(todoId).update({
//       'status': 0,
//       'updated_date': Timestamp.now(), // Optionally update timestamp
//     });

//     if (!mounted) return;
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text('Todo status updated!')));
//   } on FirebaseException catch (e) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(e.code)));
//   }
// }
