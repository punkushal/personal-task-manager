import 'package:flutter/foundation.dart';
import 'package:personal_task_manager/models/category_model.dart';
import 'package:personal_task_manager/services/auth_service.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  bool isVisible = false;

  final TaskService _taskService = TaskService();
  final List<CategoryModel> _categories = [];
  List<TaskModel> _tasksList = [];
  List<TaskModel> get tasksList => _tasksList;

  Priority? _selectedPriority;
  Priority? _appliedPriority;
  String? _selectedCategory;
  String? _appliedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isFiltering = false;

  Priority? get selectedPriority => _selectedPriority;
  Priority? get appliedPriority => _appliedPriority;
  String? get selectedCategory => _selectedCategory;
  String? get appliedCategory => _appliedCategory;
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

  void setCategory(String? category) {
    _selectedCategory = category;
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
    _appliedCategory = _selectedCategory;
    _isFiltering = true;
    notifyListeners();
  }

  void resetFilters() {
    _selectedPriority = null;
    _startDate = null;
    _endDate = null;
    _selectedCategory = null;
    _isFiltering = false;
    notifyListeners();
  }

  //get tasks from user search query
  void searchTask(String query) async {
    if (query.isEmpty) {
      _tasksList = [];
      notifyListeners();
      return;
    }
    _tasksList =
        await _taskService.getTasks(AuthService().auth.currentUser!.uid, query);
    notifyListeners();
  }

  Stream<List<TaskModel>> getFilteredTasks(String userId) {
    return _taskService.getFilteredTasks(
      userId,
      priority: _isFiltering ? _appliedPriority : null,
      startDate: _isFiltering ? _startDate : null,
      category: _isFiltering ? _appliedCategory : null,
    );
  }

  void toggleVissibility() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
