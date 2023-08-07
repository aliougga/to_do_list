import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';

import '../models/category.dart';
import '../services/db_helper.dart';

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
                    child:const CircleAvatar(
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
                  hintText: "Choose a date and time",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          _selectedDate ?? DateTime.now()),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        _selectedDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final newTask = Task(
              title: _titleController.text,
              dueDate: _selectedDate,
              completed: false,
              category: _selectedCategory,
              createdDate: DateTime.now(),
            );

            await _insertTask(newTask);
            
            Navigator.pop(context,  _selectedCategory?.id);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Future<void> _insertTask(Task task) async {
    await dbHelper.insertTask(task);
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
      items: categories.map<DropdownMenuItem<TCategory>>((category) {
        return DropdownMenuItem<TCategory>(
          value: category,
          child: Text(
              category.name!), // Remplacez categoryName par le champ approprié
        );
      }).toList(),
    );
  }

  Future<Widget?> _addCategoryWidget() async {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      
      builder: (context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
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
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final category = TCategory(
                          name: _nameController.text,
                        );
                        await _insertCategory(category);
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
