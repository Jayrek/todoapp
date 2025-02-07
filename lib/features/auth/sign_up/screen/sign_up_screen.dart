import 'package:flutter/material.dart';
import 'package:todoapp/shared/widgets/custom_elevated_button_widget.dart';
import 'package:todoapp/shared/widgets/custom_textformfield_widget.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                        labelText: 'REGISTER',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {}
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
}
