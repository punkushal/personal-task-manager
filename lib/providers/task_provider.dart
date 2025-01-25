import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:personal_task_manager/models/category_model.dart';

import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  bool isVisible = false;

  final TaskService _taskService = TaskService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CategoryModel> _categories = [];

  Priority? _selectedPriority;
  Priority? _appliedPriority;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isFiltering = false;

  Priority? get selectedPriority => _selectedPriority;
  Priority? get appliedPriority => _appliedPriority;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  bool get isFiltering => _isFiltering;

  final List<CategoryModel> _predefinedCategories = [
    CategoryModel(name: 'Food'),
    CategoryModel(name: 'Education'),
    CategoryModel(name: 'Travel'),
    CategoryModel(name: 'Health'),
    CategoryModel(name: 'Entertainment'),
  ];
  List<CategoryModel> get categories => [
        ..._predefinedCategories,
        ..._categories,
      ];

  void setPriority(Priority? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setStartDate(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime? date) {
    _endDate = date;
    notifyListeners();
  }

  void applyFilters() {
    _appliedPriority = _selectedPriority;
    _isFiltering = true;
    notifyListeners();
  }

  void resetFilters() {
    _selectedPriority = null;
    _startDate = null;
    _endDate = null;
    _isFiltering = false;
    notifyListeners();
  }

  Stream<List<TaskModel>> getFilteredTasks(String userId) {
    return _taskService.getFilteredTasks(
      userId,
      priority: _isFiltering ? _appliedPriority : null,
      startDate: _isFiltering ? _startDate : null,
    );
  }

  Future<void> addCategory(CategoryModel category, String userId) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .add(category.toMap());

      category = CategoryModel(
        id: docRef.id,
        name: category.name,
      );

      _categories.add(category);
      notifyListeners();
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  Future<void> fetchCategories(String userId) async {
    try {
      final categoriesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('categories')
          .get();

      _categories = categoriesSnapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void toggleVissibility() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
