import 'package:cloud_firestore/cloud_firestore.dart';

enum Priority { low, medium, high }

class TaskModel {
  final String? id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final Priority priority;
  final String? category;
  final String userId;

  TaskModel({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.priority = Priority.low,
    this.category,
    required this.userId,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: Priority.values[data['priority']],
      category: data['categoryId'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.index,
      'categoryId': category,
      'userId': userId,
    };
  }
}
