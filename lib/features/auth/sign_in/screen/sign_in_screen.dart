import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:todoapp/shared/widgets/custom_elevated_button_widget.dart';
import 'package:todoapp/shared/widgets/custom_textformfield_widget.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                          'Log In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -2,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          'Please sign in to continue',
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
                          labelText: 'LOGIN',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _signInUser(_emailController.text,
                                  _passwordController.text);
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
        ));
  }

  Future<void> _signInUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('credential: $credential');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password!');
      }
    }
  }
}
