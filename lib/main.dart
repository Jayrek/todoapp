// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:todoapp/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:todoapp/firebase_options.dart';
import 'package:todoapp/shared/widgets/custom_elevated_button_widget.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'My ToDo LiSt',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: -2,
              fontSize: 50,
            ),
          ),
          const Text(
            'Welcome back!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: -2,
              fontSize: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButtonWidget(
                        backgroundColor: Colors.black87,
                        labelText: 'LOGIN',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account yet?",
                      style: TextStyle(fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ));
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
