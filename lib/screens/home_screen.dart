import 'package:flutter/material.dart';
import 'package:personal_task_manager/screens/add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Task Manager'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => AddTaskScreen(
                userId: '1',
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
