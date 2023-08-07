import 'package:flutter/foundation.dart';

import '../models/notification.dart';



class NotificationProvider with ChangeNotifier {
 final List<TNotification> _notifications = [];

  List<TNotification> get notifications => _notifications;

  void addNotification(TNotification notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void updateNotification(TNotification updatedNotification) {
    final index = _notifications.indexWhere((notification) => notification.id == updatedNotification.id);
    if (index >= 0) {
      _notifications[index] = updatedNotification;
      notifyListeners();
    }
  }

  void deleteNotification(String notificationId) {
    _notifications.removeWhere((notification) => notification.id == notificationId as int);
    notifyListeners();
  }
}
