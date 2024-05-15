import '../utils/date_utils.dart';

class TNotification {
  int? id;
  int? taskId;
  String? title;
  String? description;
  DateTime? dateTime;

  TNotification({
    this.id,
    this.taskId,
    this.title,
    this.description,
    this.dateTime,
  });

  // Convertir un objet Notification en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'dateTime': DateUtils.dateToString(dateTime!),
      'description': description
    };
  }

  // Créer un objet Notification à partir d'un Map
  static TNotification fromMap(Map<String, dynamic> map) {
    return TNotification(
        id: map['id'],
        taskId: map['taskId'],
        title: map['title'],
        dateTime: DateUtils.stringToDate(map['dateTime']),
        description: map['description']);
  }
}
