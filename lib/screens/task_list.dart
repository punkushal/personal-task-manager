import 'package:flutter/material.dart';
import 'package:personal_task_manager/providers/task_provider.dart';
import 'package:personal_task_manager/screens/add_task_screen.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import 'package:personal_task_manager/utils/helper_function.dart';
import 'package:personal_task_manager/widgets/app_text.dart';
import 'package:personal_task_manager/widgets/task_detail.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();

  // Filter variables
  DateTime? _startDate;
  DateTime? _endDate;

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10,
                children: [
                  // Priority Filter
                  DropdownButton<Priority>(
                    hint: Text('Select Priority'),
                    value: taskProvider.selectedPriority,
                    onChanged: (Priority? newValue) {
                      taskProvider.setPriority(newValue);
                    },
                    items: Priority.values
                        .map<DropdownMenuItem<Priority>>((Priority priority) {
                      return DropdownMenuItem<Priority>(
                        value: priority,
                        child: Text(priority.toString().split('.').last),
                      );
                    }).toList(),
                  ),

                  // Date Range Picker
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: ctx,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              taskProvider.setStartDate(pickedDate);
                            }
                          },
                          child: Text(taskProvider.startDate == null
                              ? 'Due Date'
                              : taskProvider.startDate!
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: ctx,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            setState(() {
                              _endDate = pickedDate;
                            });
                          },
                          child: Text(_endDate == null
                              ? 'End Date'
                              : 'To: ${_endDate!.toLocal().toString().split(' ')[0]}'),
                        ),
                      ),
                    ],
                  ),

                  // Apply Filters Button
                  ElevatedButton(
                    onPressed: () {
                      taskProvider.applyFilters();
                      Navigator.pop(ctx);
                    },
                    child: Text('Apply Filters'),
                  ),

                  // Reset Filters Button
                  TextButton(
                    onPressed: () {
                      taskProvider.resetFilters();
                      Navigator.pop(ctx);
                    },
                    child: Text('Reset Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return StreamBuilder<List<TaskModel>>(
            stream: taskProvider.getFilteredTasks(
              userId,
            ),
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
                      Text('No tasks yet',
                          style: TextStyle(color: Colors.grey)),
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
