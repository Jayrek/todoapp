import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/core/service/notification_service.dart';
import 'package:todoapp/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:todoapp/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:todoapp/features/home/screen/home_screen.dart';
import 'package:todoapp/features/todo/screen/add_todo_screen.dart';
import 'package:todoapp/features/todo_list/screen/todo_list_screen.dart';
import 'package:todoapp/firebase_options.dart';

import 'features/notification/notification_screen.dart';
import 'features/splash/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService().initFirebaseMessaging();
  // await NotificationService().setupFlutterNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'My ToDo List',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/home': (context) => const HomeScreen(),
        '/signIn': (context) => const SignInScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/todoList': (context) => const TodoListScreen(),
        '/addTodo': (context) => const AddTodoScreen(),
      },
    );
  }
}
