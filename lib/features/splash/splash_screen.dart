import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> getSignedInUser() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('getSignedInUser: $user');

    if (!mounted) return;
    if (user == null) {
      // navigate to home screen - no current user
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } else {
      // currently has user signed in
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/todoList', (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    getSignedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'My ToDo LiSt',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: -2,
              fontSize: 50,
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(),
        ],
      )),
    );
  }
}
