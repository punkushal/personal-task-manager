import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    checkConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _isOnline = result.contains(ConnectivityResult.wifi) ? true : false;
    notifyListeners();
  }
}
