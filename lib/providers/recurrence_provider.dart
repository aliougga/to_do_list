import 'package:flutter/foundation.dart';

import '../models/recurring_type.dart';

class RecurrenceProvider with ChangeNotifier {
 final List<Recurrence> _recurrences = [];

  List<Recurrence> get recurrences => _recurrences;

  void addRecurrence(Recurrence recurrence) {
    _recurrences.add(recurrence);
    notifyListeners();
  }

  void updateRecurrence(Recurrence updatedRecurrence) {
    final index = _recurrences.indexWhere((recurrence) => recurrence.id == updatedRecurrence.id);
    if (index >= 0) {
      _recurrences[index] = updatedRecurrence;
      notifyListeners();
    }
  }

  void deleteRecurrence(String recurrenceId) {
    _recurrences.removeWhere((recurrence) => recurrence.id == recurrenceId as int);
    notifyListeners();
  }
}
