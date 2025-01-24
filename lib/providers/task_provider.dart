import 'package:flutter/foundation.dart';

class TaskProvider with ChangeNotifier {
  bool isVisible = false;

  void toggleVissibility() {
    isVisible = !isVisible;
    notifyListeners();
  }
}
