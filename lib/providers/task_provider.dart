import 'package:flutter/foundation.dart';

class TaskProvider with ChangeNotifier {
  bool isToggle = false;

  void toggleVissibility() {
    isToggle = !isToggle;
    notifyListeners();
  }
}
