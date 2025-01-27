import 'package:flutter/material.dart';
import 'package:personal_task_manager/providers/task_provider.dart';
import 'package:personal_task_manager/widgets/app_text_formfield.dart';
import 'package:provider/provider.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({super.key});

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  final queryController = TextEditingController();

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return AppTextFormField(
      controller: queryController,
      prefixIcon: Icons.search,
      hintText: 'Search',
      onChanged: (query) {
        taskProvider.searchTask(query);
      },
    );
  }
}
