import 'package:flutter/material.dart';
import 'package:personal_task_manager/screens/add_task_screen.dart';
import 'package:personal_task_manager/screens/profile_screen.dart';
import 'package:personal_task_manager/screens/search_screen.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import 'package:personal_task_manager/screens/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = AuthService();
  int _currentIndex = 0;
  List<Widget> screens = [
    TaskListScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];
  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => AddTaskScreen(
                userId: authService.auth.currentUser!.uid,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: onTapped,
      ),
    );
  }
}
