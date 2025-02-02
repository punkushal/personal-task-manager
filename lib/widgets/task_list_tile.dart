import 'package:flutter/material.dart';
import 'package:personal_task_manager/providers/theme_provider.dart';
import 'package:personal_task_manager/widgets/app_text.dart';
import 'package:personal_task_manager/widgets/task_detail.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../screens/add_task_screen.dart';
import '../services/task_service.dart';
import '../utils/helper_function.dart';

class TaskListTile extends StatelessWidget {
  final TaskModel task;
  final String userId;
  final TaskService taskService;

  const TaskListTile({
    super.key,
    required this.task,
    required this.userId,
    required this.taskService,
  });

  Color _getPriorityColor() {
    switch (task.priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  Future<void> _deleteTask(
      BuildContext context, TaskService taskService, TaskModel task) async {
    try {
      await taskService.deleteTask(task.id!);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close dialog
      }
      if (context.mounted) {
        showMsg(
            context, 'Failed to delete the task :${e.toString()}', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getPriorityColor(),
          child: Icon(Icons.task, color: Colors.white),
        ),
        title: AppText(
          text: task.title,
          fontWeight: FontWeight.bold,
        ),
        subtitle: Text(
          '${task.dueDate.toLocal().toString().split(' ')[0]} - ${task.description ?? ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: theme.isDarkMode ? Colors.white38 : null),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (ctx) => [
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => AddTaskScreen(
                    userId: userId,
                    existingTask: task,
                  ),
                ),
              );
            } else if (value == 'delete') {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: AppText(text: 'Delete Task'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(text: 'Are you sure to delete this task?'),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            _deleteTask(context, taskService, task);
                            Navigator.pop(context);
                            showMsg(
                              context,
                              'Successfully deleted the task',
                              Colors.blue,
                            );
                          },
                          child: Center(child: AppText(text: 'Yes')),
                        ),
                      ],
                    );
                  });
            }
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => TaskDetail(task: task),
            ),
          );
        },
      ),
    );
  }
}
