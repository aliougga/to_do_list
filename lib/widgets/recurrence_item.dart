import 'package:flutter/material.dart';

import '../models/recurring_type.dart';


class RecurrenceItem extends StatelessWidget {
  final Recurrence recurrence;

 const RecurrenceItem({super.key, required this.recurrence});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(recurrence.recurringType.toString()),
      subtitle: Text(recurrence.recurringValue.toString()),
    );
  }
}
