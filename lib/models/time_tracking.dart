class TimeTracking {
  int? id;
  int? taskId;
  DateTime? startTime;
  DateTime? endTime;
  Duration? duration;

  TimeTracking({
    this.id,
    this.taskId,
    this.startTime,
    this.endTime,
    this.duration,
  });

  // Convertir un objet TimeTracking en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'startTime': startTime!.millisecondsSinceEpoch,
      'endTime': endTime!.millisecondsSinceEpoch,
      'duration': duration!.inSeconds,
    };
  }

  // Créer un objet TimeTracking à partir d'un Map
  static TimeTracking fromMap(Map<String, dynamic> map) {
    return TimeTracking(
      id: map['id'],
      taskId: map['taskId'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime']),
      duration: Duration(seconds: map['duration']),
    );
  }
}
