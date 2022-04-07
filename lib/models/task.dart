import 'package:to_do_list/utils/dbhelper.dart';

class Task {
  int? taskId;
  String? taskTitle;
  String? taskDate;
  String? taskTime;
  bool? isTaskDone;
  int? myCategory;

  Task(
      {this.taskId,
      required this.taskTitle,
      required this.taskDate,
      required this.taskTime,
      this.isTaskDone,
      this.myCategory});

  Task.fromMap(Map<String, dynamic> map) {
    taskId = map['id'];
    taskTitle = map['title'];
    taskDate = map['date'];
    taskTime = map['time'];
    isTaskDone = isDoneFromString(map['is_done']);
    myCategory = map['my_category'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.taskId: taskId,
      DatabaseHelper.taskTitle: taskTitle,
      DatabaseHelper.taskDate: taskDate,
      DatabaseHelper.taskTime: taskTime,
      DatabaseHelper.taskDone: isDoneAsInt(isTaskDone),
      DatabaseHelper.taskCategory: myCategory
    };
  }

  int isDoneAsInt(val) {
    if (val == true) {
      return 1;
    } else {
      return 0;
    }
  }

  bool isDoneFromString(val) {
    if (val == 1) {
      return true;
    } else {
      return false;
    }
  }
}
