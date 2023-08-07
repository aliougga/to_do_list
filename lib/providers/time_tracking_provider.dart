import 'package:flutter/foundation.dart';

import '../models/time_tracking.dart';

class TimeTrackingProvider with ChangeNotifier {
  final List<TimeTracking> _timeTrackings = [];

  List<TimeTracking> get timeTrackings => _timeTrackings;

  void addTimeTracking(TimeTracking timeTracking) {
    _timeTrackings.add(timeTracking);
    notifyListeners();
  }

  void updateTimeTracking(TimeTracking updatedTimeTracking) {
    final index = _timeTrackings.indexWhere((timeTracking) => timeTracking.id == updatedTimeTracking.id);
    if (index >= 0) {
      _timeTrackings[index] = updatedTimeTracking;
      notifyListeners();
    }
  }

  void deleteTimeTracking(String timeTrackingId) {
    _timeTrackings.removeWhere((timeTracking) => timeTracking.id == timeTrackingId as int);
    notifyListeners();
  }
}
