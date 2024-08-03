import 'dart:async';
import 'package:flutter/material.dart';

class GlobalStopwatch {
  static final GlobalStopwatch _instance = GlobalStopwatch._internal();

  factory GlobalStopwatch() {
    return _instance;
  }

  GlobalStopwatch._internal();

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final _listeners = <VoidCallback>[];

  bool isRunning() {
    if (_stopwatch.isRunning) {
      return true;
    }
    return false;
  }

  void start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _notifyListeners();
      });
    }
  }

  void stop() {
    _stopwatch.stop();
    _timer?.cancel();
    _notifyListeners();
  }

  void reset() {
    _stopwatch.reset();
    _notifyListeners();
  }

  Duration get elapsed => _stopwatch.elapsed;

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}
