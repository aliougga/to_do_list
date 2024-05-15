import 'package:flutter/material.dart';
import 'package:to_do_list/services/notification_service.dart';

import '../models/task.dart';
import '../utils/date_utils.dart' as date_utils;

class TaskItem extends StatefulWidget {
  final Task task;
  final Function() onTap;
  final Function() onEdit;
  final Function() onDelete;
  final Function() onValid;

  const TaskItem(
      {super.key,
      required this.task,
      required this.onTap,
      required this.onEdit,
      required this.onDelete,
      required this.onValid});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      leading: Checkbox(
        value: widget.task.completed,
        onChanged: (_) => widget.onValid(),
        activeColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Text(
        widget.task.title!,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          decoration: widget.task.completed!
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        date_utils.DateUtils.formatDateTime(widget.task.dueDate!),
        style: TextStyle(
            fontSize: 14,
            fontStyle:
                widget.task.completed! ? FontStyle.italic : FontStyle.normal),
      ),
      trailing: IconButton(
        icon: Icon(
          widget.task.notificationEnabled!
              ? Icons.notifications_active_outlined
              : Icons.notifications_off_outlined,
          size: 28,
        ),
        onPressed: () {
          _handleNotification(widget.task);
        },
      ),
      onTap: () => widget.onTap(),
      onLongPress: () => _showBottomSheet(context),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 10,
      ),
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: !widget.task.completed! ? 200 : 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit,
                ),
                title: const Text('Edit'),
                onTap: () => {
                  Navigator.of(context).pop(),
                  widget.onEdit(),
                },
              ),
              ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () => {
                        Navigator.of(context).pop(),
                        _showDeleteConfirmationDialog(context),
                      }),
              !widget.task.completed!
                  ? ListTile(
                      leading: const Icon(Icons.check),
                      title: const Text('Mark as Done'),
                      onTap: () => {
                        Navigator.of(context).pop(),
                        widget.onValid(),
                      },
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
                widget.onDelete();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  _handleNotification(Task task) {
    task.notificationEnabled = !task.notificationEnabled!;
    task.notificationEnabled!
        ? NotificationService().showNotification(task.toNotification())
        : NotificationService().remokeNotification(task.id!);
    setState(() {});
  }
}
