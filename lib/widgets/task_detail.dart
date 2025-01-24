import 'package:flutter/material.dart';
import 'package:personal_task_manager/models/task_model.dart';
import 'package:personal_task_manager/widgets/app_text.dart';

class TaskDetail extends StatelessWidget {
  final TaskModel task;
  const TaskDetail({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: 'Title',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  AppText(text: task.title),
                  Divider(),
                  AppText(
                    text: 'Descriptions',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  AppText(text: task.description!),
                  Divider(),
                  AppText(
                    text: 'Due date',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  AppText(
                      text: task.dueDate.toLocal().toString().split(' ')[0]),
                  Divider(),
                  AppText(
                    text: 'Priority',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  AppText(text: task.priority.name),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
