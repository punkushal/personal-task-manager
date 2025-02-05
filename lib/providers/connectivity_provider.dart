import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  late StreamSubscription<InternetStatus> _streamSubscription;

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    _streamSubscription = InternetConnection().onStatusChange.listen((status) {
      _isOnline = status == InternetStatus.connected;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
