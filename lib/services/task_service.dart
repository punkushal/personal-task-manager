import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create Task
  Future<void> addTask(TaskModel task) async {
    try {
      await _firestore.collection('tasks').add(task.toFirestore());
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  // Read Tasks
  Stream<List<TaskModel>> getTasks(String userId) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }

  // Update Task
  Future<void> updateTask(TaskModel task) async {
    try {
      await _firestore
          .collection('tasks')
          .doc(task.id)
          .update(task.toFirestore());
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
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

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }
}
