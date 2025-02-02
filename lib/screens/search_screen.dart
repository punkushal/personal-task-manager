import 'package:flutter/material.dart';
import 'package:personal_task_manager/providers/task_provider.dart';
import 'package:personal_task_manager/providers/theme_provider.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import 'package:personal_task_manager/services/task_service.dart';
import 'package:personal_task_manager/widgets/search_task.dart';
import 'package:provider/provider.dart';

import '../widgets/task_list_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final taskService = TaskService();
  final userId = AuthService().auth.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? null : Colors.white,
        title: SearchTask(),
      ),
      body: ListView.builder(
          itemCount: taskProvider.tasksList.length,
          itemBuilder: (ctx, index) {
            final task = taskProvider.tasksList[index];
            return TaskListTile(
                task: task, userId: userId, taskService: taskService);
          }),
    );
  }
}
