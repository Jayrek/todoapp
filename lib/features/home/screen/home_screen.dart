import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytodolist/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:mytodolist/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:mytodolist/shared/widgets/custom_elevated_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoadingUser = true;

  void getSignedInUser() {
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   // user is signed in
    //   Navigator.of(context)
    //       .pushNamedAndRemoveUntil('/todoList', (route) => false);
    // }
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // user is signed in
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/todoList', (route) => false);
      }
    });
    setState(() => isLoadingUser = false);
  }

  @override
  void initState() {
    super.initState();
    getSignedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: isLoadingUser
          ? const CircularProgressIndicator()
          : Column(
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
                              childWidget: const Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInScreen(),
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
                                    builder: (context) => const SignUpScreen(),
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
