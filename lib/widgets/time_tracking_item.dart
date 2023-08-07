import 'package:flutter/material.dart';
import '../models/time_tracking.dart';
import '../utils/date_utils.dart' as date_utils;


class TimeTrackingItem extends StatelessWidget {
  final TimeTracking timeTracking;

  const TimeTrackingItem({super.key, required this.timeTracking});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(timeTracking.duration as String),
      subtitle: Text(date_utils.DateUtils.formatDuration(timeTracking.duration!)),
    );
  }
}
