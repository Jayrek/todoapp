import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mytodolist/features/auth/sign_in/screen/sign_in_screen.dart';
// import 'package:mytodolist/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:mytodolist/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:mytodolist/features/home/screen/home_screen.dart';
import 'package:mytodolist/features/todo/screen/add_todo_screen.dart';
import 'package:mytodolist/features/todo_list/screen/todo_list_screen.dart';
// import 'package:mytodolist/features/todo_list/screen/todo_list_screen.dart';
import 'package:mytodolist/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My ToDo List',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/signIn': (context) => const SignInScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/todoList': (context) => const TodoListScreen(),
        '/addTodo': (context) => const AddTodoScreen(),
      },
      // home: const HomePage(),
      // home: const TodoListScreen(ownerId: '1jOy0FR6VUeCkwZHAHHJ2jdm6vt2'),
    );
  }
}
