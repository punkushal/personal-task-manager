import 'package:flutter/material.dart';
import 'package:personal_task_manager/providers/task_provider.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../utils/helper_function.dart';
import '../widgets/app_text.dart';
import '../widgets/app_text_formfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final service = AuthService();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSigningUp() async {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).clearSnackBars();
      await service.createUserWithEmailAndPassword(emailController.text,
          passwordController.text, nameController.text, context);
      return;
    }
    showMsg(context, 'Failed to register', Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                AppText(
                  text: 'Create an account',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                AppText(
                  text: 'Welcome! Please enter your details.',
                  color: Colors.grey,
                ),

                SizedBox(
                  height: 16,
                ),
                //Related to Name Input field
                AppText(
                  text: 'Name',
                  fontWeight: FontWeight.bold,
                ),
                AppTextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.length > 20) {
                      return 'name characters length should be within 20';
                    } else if (value.length < 5) {
                      return 'name characters length should be greater than 5';
                    }
                    if (value.isEmpty) {
                      return 'name field must not be empty';
                    }
                    return null;
                  },
                  hintText: 'Enter your name',
                  prefixIcon: Icons.person_2_outlined,
                ),
                SizedBox(
                  height: 8,
                ),
                //Related to email Input field
                AppText(
                  text: 'Email',
                  fontWeight: FontWeight.bold,
                ),
                AppTextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email field must not be empty';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  hintText: 'Enter your email',
                  prefixIcon: Icons.mail_outline,
                ),

                SizedBox(
                  height: 8,
                ),

                //Related to password Input field
                AppText(
                  text: 'Password',
                  fontWeight: FontWeight.bold,
                ),
                Consumer<TaskProvider>(
                  builder: (context, provider, child) {
                    return AppTextFormField(
                      controller: passwordController,
                      obscureText: provider.isToggle ? true : false,
                      validator: (value) {
                        if (value!.length > 16 && value.length < 8) {
                          return 'Password characters length should be within 8 to 16';
                        } else if (value.isEmpty) {
                          return 'Password field must not be empty';
                        }
                        return null;
                      },
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: InkWell(
                        onTap: () {
                          provider.toggleVissibility();
                        },
                        child: Icon(
                          provider.isToggle
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 28,
                ),
                Center(
                    child: Column(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: onSigningUp,
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(
                          deviceWidth * 0.9,
                          40,
                        ),
                      ),
                      child: AppText(
                        text: 'Sign Up',
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 6,
                      children: [
                        AppText(text: 'Already have an account?'),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (ctx) => LoginScreen(),
                        //       ),
                        //     );
                        //   },
                        //   child: AppText(
                        //     text: 'Log in',
                        //     color: Colors.blue,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
