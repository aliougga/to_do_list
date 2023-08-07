enum RecurringType {
  daily,
  weekly,
  monthly,
}

class Recurrence {
  int? id;
  int? taskId;
  RecurringType? recurringType;
  int? recurringValue;

  Recurrence({
    this.id,
    this.taskId,
    this.recurringType,
    this.recurringValue,
  });

  // Convertir un objet Recurrence en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'recurringType': recurringType!.index,
      'recurringValue': recurringValue,
    };
  }

  // Créer un objet Recurrence à partir d'un Map
  static Recurrence fromMap(Map<String, dynamic> map) {
    return Recurrence(
      id: map['id'],
      taskId: map['taskId'],
      recurringType: RecurringType.values[map['recurringType']],
      recurringValue: map['recurringValue'],
    );
  }
}
