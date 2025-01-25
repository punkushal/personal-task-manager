import 'package:flutter/material.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import 'package:personal_task_manager/widgets/app_text.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  final authService = AuthService();
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Switch(
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(86.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                AppText(
                  text: 'Email : ${authService.auth.currentUser!.email!}',
                  fontWeight: FontWeight.bold,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await authService.auth.signOut();
                  },
                  child: Text('Log out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
