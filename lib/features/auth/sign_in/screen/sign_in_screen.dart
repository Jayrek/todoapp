import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytodolist/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:mytodolist/shared/widgets/custom_elevated_button_widget.dart';
import 'package:mytodolist/shared/widgets/custom_textformfield_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoggingIn = false;

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
                          childWidget: isLoggingIn
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
        ));
  }

  Future<void> _signInUser(String email, String password) async {
    try {
      setState(() => isLoggingIn = true);

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        debugPrint('credential: $credential');
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
            context, '/todoList', (route) => false);
      }
      setState(() => isLoggingIn = false);
    } on FirebaseAuthException catch (e) {
      setState(() => isLoggingIn = false);
      if (e.code == 'invalid-credential') {
        debugPrint('Invalid credential!');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password!');
      } else {
        debugPrint(e.code);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }
}
