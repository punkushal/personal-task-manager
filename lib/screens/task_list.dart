import 'package:flutter/material.dart';
import 'package:personal_task_manager/providers/task_provider.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import 'package:personal_task_manager/widgets/app_text.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../widgets/task_list_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();

  // Filter variables
  DateTime? _startDate;

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<Priority>(
                        hint: AppText(text: 'Select Priority'),
                        value: taskProvider.selectedPriority,
                        onChanged: (Priority? newValue) {
                          taskProvider.setPriority(newValue);
                        },
                        items: Priority.values.map<DropdownMenuItem<Priority>>(
                            (Priority priority) {
                          return DropdownMenuItem<Priority>(
                            value: priority,
                            child: Text(priority.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                      DropdownButton<String>(
                        value: taskProvider.selectedCategory,
                        hint: AppText(text: 'Category'),
                        items: taskProvider.categories
                            .map((category) => DropdownMenuItem(
                                  value: category.name,
                                  child: Text(category.name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          taskProvider.setCategory(value);
                        },
                      ),
                    ],
                  ),

                  // Date Range Picker
                  ElevatedButton(
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
                    child: AppText(
                      text: taskProvider.startDate == null
                          ? 'Due Date'
                          : taskProvider.startDate!
                              .toLocal()
                              .toString()
                              .split(' ')[0],
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),

                  // Apply Filters Button
                  ElevatedButton(
                    onPressed: () {
                      taskProvider.applyFilters();
                      Navigator.pop(ctx);
                    },
                    child: AppText(
                      text: 'Apply Filters',
                      color: Colors.white,
                    ),
                  ),

                  // Reset Filters Button
                  TextButton(
                    onPressed: () {
                      taskProvider.resetFilters();
                      Navigator.pop(ctx);
                    },
                    child: AppText(text: 'Reset Filters'),
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
