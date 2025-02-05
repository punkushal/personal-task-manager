import 'package:flutter/material.dart';
import 'package:personal_task_manager/providers/connectivity_provider.dart';
import 'package:personal_task_manager/providers/task_provider.dart';
import 'package:personal_task_manager/screens/home_screen.dart';
import 'package:personal_task_manager/screens/signup_screen.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import 'package:personal_task_manager/utils/helper_function.dart';
import 'package:provider/provider.dart';
import '../widgets/app_text.dart';
import '../widgets/app_text_formfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final service = AuthService();

  bool isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLogin() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      await service.loginUser(
          emailController.text, passwordController.text, context);
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final internetProvider = Provider.of<ConnectivityProvider>(context);
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              AppText(
                text: 'Login',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              AppText(
                text: 'Welcome back! Please enter your details.',
                color: Colors.grey,
              ),

              SizedBox(
                height: 16,
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
                builder: (context, provider, child) => AppTextFormField(
                  controller: passwordController,
                  obscureText: provider.isVisible ? false : true,
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
                      provider.isVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Center(
                  child: Column(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (internetProvider.isOnline) {
                        onLogin();
                        return;
                      }
                      showInternetConnectionErroMsg(context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(
                        deviceWidth * 0.9,
                        40,
                      ),
                    ),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : AppText(
                            text: 'Log In',
                            color: Colors.white,
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      AppText(text: "Don't have an account?"),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => SignupScreen()));
                        },
                        child: AppText(
                          text: 'Sign up',
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
