import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import 'package:personal_task_manager/services/notification_service.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();
  // Create Task
  Future<void> addTask(TaskModel task) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('tasks').add(task.toFirestore());

      final updatedTask = TaskModel(
        id: docRef.id, // Assign Firestore-generated ID
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        category: task.category,
        userId: task.userId,
      );
      _notificationService.scheduleTaskNotification(updatedTask);
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  // Read Tasks
  Future<List<TaskModel>> getTasks(String userId, String queryTitle) async {
    QuerySnapshot snapshot = await _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    List<TaskModel> tasks =
        snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    // Client-side title filtering
    if (queryTitle.isEmpty) {
      return [];
    }
    tasks = tasks
        .where((task) =>
            task.title.toLowerCase().contains(queryTitle.toLowerCase()))
        .toList();
    return tasks;
  }

  // Update Task
  Future<void> updateTask(TaskModel task) async {
    try {
      await _firestore
          .collection('tasks')
          .doc(task.id)
          .update(task.toFirestore());
      _notificationService.scheduleTaskNotification(task);
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('tasks')
          .where('userId', isEqualTo: AuthService().auth.currentUser!.uid)
          .get();

      List<TaskModel> tasks =
          snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
      await _firestore.collection('tasks').doc(taskId).delete();
      final task = tasks.singleWhere((task) => task.id == taskId);
      _notificationService.cancelTaskNotification(task);
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  // Filter Tasks
  Stream<List<TaskModel>> getFilteredTasks(
    String userId, {
    Priority? priority,
    DateTime? startDate,
    String? category,
    String? queryTitle,
  }) {
    Query query =
        _firestore.collection('tasks').where('userId', isEqualTo: userId);

    if (priority != null) {
      query = query.where('priority', isEqualTo: priority.index);
    }

    if (startDate != null) {
      query = query.where('dueDate', isEqualTo: startDate);
    }

    if (category != null) {
      query = query.where('categoryId', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      List<TaskModel> tasks =
          snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();

      // Client-side title filtering
      if (queryTitle != null && queryTitle.isNotEmpty) {
        tasks = tasks
            .where((task) =>
                task.title.toLowerCase().contains(queryTitle.toLowerCase()))
            .toList();
      }

      return tasks;
    });
  }
}
