import 'package:flutter/material.dart';
import 'package:personal_task_manager/screens/add_task_screen.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import 'package:personal_task_manager/utils/helper_function.dart';
import 'package:personal_task_manager/widgets/app_text.dart';
import 'package:personal_task_manager/widgets/task_detail.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskListScreen extends StatelessWidget {
  final TaskService _taskService = TaskService();

  TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AuthService();
    final String userId = service.auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter dialog
            },
          ),
        ],
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: _taskService.getTasks(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 100, color: Colors.grey),
                  Text('No tasks yet', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              TaskModel task = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                child: TaskListTile(
                  task: task,
                  userId: userId,
                  taskService: _taskService,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

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
                      title: Text('Delete Task'),
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
                          child: Center(child: Text('Yes')),
                        ),
                      ],
                    );
                  });
            }
          },
        ),
        onTap: () {
          // TODO: Navigate to task details
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
