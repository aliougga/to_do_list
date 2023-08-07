import 'package:to_do_list/models/notification.dart';
import 'package:to_do_list/utils/date_utils.dart';

import 'category.dart';

class Task {
  int? id;
  String? title;
  String? description;
  TCategory? category;
  DateTime? dueDate;
  bool? completed;
  DateTime? createdDate;

  Task({
    this.id,
    this.title,
    this.description,
    this.category,
    this.dueDate,
    this.completed,
    this.createdDate,
  });
  // Convertir un objet Task en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': category!.id,
      'dueDate': DateUtils.dateToString(dueDate!),
      'completed': completed! ? 1 : 0,
      'createdDate': DateUtils.dateToString(createdDate!),
    };
  }

  // Créer un objet Task à partir d'un Map
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: TCategory(id: map['categoryId']),
      dueDate: DateUtils.stringToDate(map['dueDate']),
      completed: map['completed'] == 1,
      createdDate: DateUtils.stringToDate(map['createdDate']),
    );
  }

  // Créer une TNotifcation à partir d'une tache
  TNotification toNotification() {
    return TNotification(
        id: id,
        taskId: id,
        dateTime: dueDate,
        title: title,
        description: description);
  }
}
