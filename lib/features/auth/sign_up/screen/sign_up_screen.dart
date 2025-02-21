import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytodolist/shared/widgets/custom_elevated_button_widget.dart';
import 'package:mytodolist/shared/widgets/custom_textformfield_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2,
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        'Crete your account',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomTextFormFieldWidget(
                      icon: Icons.person,
                      controller: _fullNameController,
                      hintText: 'Full name',
                      labelText: 'Full name',
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormFieldWidget(
                      icon: Icons.email,
                      controller: _emailController,
                      hintText: 'Email',
                      labelText: 'Email',
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormFieldWidget(
                      icon: Icons.lock,
                      isObscure: true,
                      controller: _passwordController,
                      hintText: 'Password',
                      labelText: 'Password',
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormFieldWidget(
                      icon: Icons.lock,
                      isObscure: true,
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      labelText: 'Confirm Password',
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Password did not matched';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButtonWidget(
                        backgroundColor: Colors.black87,
                        childWidget: isSigningUp
                            ? const CircularProgressIndicator()
                            : const Text(
                                'REGISTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _signUpUser(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _fullNameController.text,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      setState(() => isSigningUp = true);
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await _addUserToFirestore(
          userId: credential.user!.uid,
          name: _fullNameController.text,
          email: email,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      } else {
        debugPrint(e.code);
      }

      if (!mounted) return;
      setState(() => isSigningUp = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  Future<void> _addUserToFirestore({
    required String userId,
    required String name,
    required String email,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final userId = auth.currentUser?.uid;

    CollectionReference user = FirebaseFirestore.instance.collection('user');
    try {
      await user.doc(userId).set({
        'id': user.doc().id,
        'uid': userId,
        'name': name,
        'email': email,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'provider': 'email',
      });
      await Future.delayed(const Duration(seconds: 3), () {
        setState(() => isSigningUp = false);
        // if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
            context, '/todoList', (route) => false);
      });
    } on FirebaseException catch (e) {
      if (!mounted) return;
      setState(() => isSigningUp = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }
}
