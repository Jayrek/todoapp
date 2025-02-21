import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user != null) {
    //     // user is signed in
    //     Navigator.of(context)
    //         .pushNamedAndRemoveUntil('/todoList', (route) => false);
    //   }
    // });
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
                          children: [
                            Expanded(
                              child: CustomElevatedButtonWidget(
                                backgroundColor: Colors.white,
                                borderColor: Colors.black87,
                                childWidget: const Text(
                                  'SIGN IN WITH GOOGLE',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  _signInWithGoogle();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomElevatedButtonWidget(
                                backgroundColor: Colors.white,
                                borderColor: Colors.black87,
                                childWidget: const Text(
                                  'SIGN IN WITH FACEBOOK',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {},
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
                                      builder: (context) =>
                                          const SignUpScreen(),
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
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      // trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // once signed in, return the UserCredential
      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? firesbaseUser = user.user;
      debugPrint('user: ${user.user}');

      if (firesbaseUser != null) {
        // saving google info to user firestore collection
        await _addUserToFirestore(
          userId: firesbaseUser.uid,
          name: firesbaseUser.displayName ?? '',
          email: firesbaseUser.email ?? '',
        );
      }
    } catch (e) {
      debugPrint('error signing in google: $e');
    }
  }

  Future<void> _addUserToFirestore({
    required String userId,
    required String name,
    required String email,
  }) async {
    CollectionReference user = FirebaseFirestore.instance.collection('user');
    try {
      await user.doc(userId).set({
        'id': user.doc().id,
        'uid': userId,
        'name': name,
        'email': email,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'provider': 'google',
      });
      await Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(
            context, '/todoList', (route) => false);
      });
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }
}
