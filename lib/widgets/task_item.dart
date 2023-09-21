import 'package:flutter/material.dart';
import 'package:to_do_list/services/notification_service.dart';
import '../utils/date_utils.dart' as date_utils;
import '../models/task.dart';

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
      title: Text(
        widget.task.title!,
        style: TextStyle(
          fontStyle:
              widget.task.completed! ? FontStyle.italic : FontStyle.normal,
          decoration: widget.task.completed!
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        date_utils.DateUtils.formatDateTime(widget.task.dueDate!),
        style: TextStyle(
          fontStyle:
              widget.task.completed! ? FontStyle.italic : FontStyle.normal,
        ),
      ),
      //tileColor: Colors.primaries[Random().nextInt(Colors.primaries.length)]
      //  [50],
      leading: Checkbox(
        value: widget.task.completed,
        onChanged: (_) => widget.onValid(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () => widget.onTap(),
      onLongPress: () => _showBottomSheet(context),
      trailing: GestureDetector(
        child: !widget.task.notificationEnabled!
            ? const Icon(Icons.notifications_off)
            : const Icon(Icons.notifications_on),
        onTap: () => {_handleNotification(widget.task)},
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width -
            10, 
      ),
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height:  !widget.task.completed! ? 200 : 150,
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
