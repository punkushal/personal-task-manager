import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  bool isVisible = false;

  final TaskService _taskService = TaskService();

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
      endDate: _isFiltering ? _endDate : null,
    );
  }

  void toggleVissibility() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
