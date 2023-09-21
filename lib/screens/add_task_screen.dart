import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/utils/date_utils.dart' as dt;
import '../models/category.dart';
import '../services/db_helper.dart';
import '../services/notification_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final dbHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TCategory? _selectedCategory;
  List<TCategory> categories = [];
  bool _enabled = false;

  Future<void> _loadCategories() async {
    final loadedCategories = await dbHelper.getAllCategories();
    setState(() {
      categories = loadedCategories;
      if (loadedCategories.isNotEmpty) {
        _selectedCategory = loadedCategories.first;
      }
    });
  }

  Future<void> _insertCategory(TCategory category) async {
    await dbHelper.insertCategory(category);
    _loadCategories();
    setState(() {});
  }

  @override
  void initState() {
    _loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _categoryCombo(),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => _addCategoryWidget(),
                    child: const CircleAvatar(
                      radius: 25.0,
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: _selectedDate == null
                      ? "Choose a date and time"
                      : dt.DateUtils.formatDateTime(_selectedDate!),
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate;
                  showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  ).then(
                    (value) => {
                      pickedDate = value,
                      if (pickedDate != null)
                        {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                _selectedDate ?? DateTime.now()),
                          ).then(
                            (value) => {
                              if (value != null)
                                {
                                  setState(
                                    () {
                                      _selectedDate = DateTime(
                                        pickedDate!.year,
                                        pickedDate!.month,
                                        pickedDate!.day,
                                        value.hour,
                                        value.minute,
                                      );
                                    },
                                  )
                                }
                            },
                          )
                        }
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Enable notification"),
                  Switch(
                    value: _enabled,
                    onChanged: (value) {
                      setState(
                        () {
                          _enabled = value;
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_selectedDate != null) {
              final newTask = Task(
                  title: _titleController.text,
                  dueDate: _selectedDate,
                  completed: false,
                  category: _selectedCategory,
                  createdDate: DateTime.now(),
                  notificationEnabled: _enabled);

              _insertTask(newTask);
              Navigator.pop(context, _selectedCategory?.id);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please choose a date")));
            }
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Future<void> _insertTask(Task task) async {
    int taskId = await dbHelper.insertTask(task);
    if (task.notificationEnabled!) {
      task.id = taskId;
      await NotificationService().showNotification(task.toNotification());
    }
  }

  Widget _categoryCombo() {
    return DropdownButtonFormField<TCategory>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Choose a category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      items: categories.map<DropdownMenuItem<TCategory>>(
        (category) {
          return DropdownMenuItem<TCategory>(
            value: category,
            child: Text(category
                .name!), // Remplacez categoryName par le champ approprié
          );
        },
      ).toList(),
    );
  }

  Future<Widget?> _addCategoryWidget() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 10,
      ),
      builder: (context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a category name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final category = TCategory(
                          name: nameController.text,
                        );
                        _insertCategory(category);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add Category'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
