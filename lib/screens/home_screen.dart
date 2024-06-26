import 'package:flutter/material.dart';
import 'package:to_do_list/local_notifications.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/screens/another_page.dart';
import 'package:to_do_list/widgets/task_item.dart';
import '../models/category.dart';
import '../services/db_helper.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool searchRound = false;
  String kw = '';
  final dbHelper = DatabaseHelper.instance;

  TCategory? selectedCategory;

  List<Task> tasks = [];
  List<TCategory> allCategories = [];
  List<Task> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    listenNotification();
    _loadCategories();
    _loadData();
  }

  listenNotification(){
    print("Listening to notification");

    LocalNotifications.onClickNotification.stream.listen((event) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> AnotherPage(event)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchRound ? _appBarSearchForm() : _getDropdown(),
        actions: [
          !searchRound
              ? IconButton(
                  icon: const Icon(Icons.search_outlined),
                  onPressed: () {
                    setState(
                      () {
                        searchRound = searchRound = true;
                      },
                    );
                  })
              : IconButton(
                  icon: const Icon(Icons.close_outlined),
                  onPressed: () {
                    setState(() {
                      kw = "";
                      searchRound = searchRound = false;
                      _getfiltredTasks();
                    });
                  },
                ),
        ],
      ),
      body: filteredTasks.isEmpty
          ? Center(
              child: Text(
                searchRound
                    ? 'No corresponding task'
                    : 'No tasks at the moment',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: TaskItem(
                    task: task,
                    onTap: () => () {},
                    onEdit: () => _navigateToEditTaskScreen(task),
                    onDelete: () => _deleteTask(task),
                    onValid: () => _toggleTaskCompletion(task),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskScreen,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getDropdown() {
    return DropdownButton<TCategory>(
      dropdownColor: Theme.of(context).primaryColor,
      value: selectedCategory,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      iconSize: 24,
      isExpanded: false,
      style: const TextStyle(color: Colors.white, fontSize: 20),
      onChanged: (newValue) {
        setState(() {
          selectedCategory = newValue!;
          _getfiltredTasks();
        });
      },
      items: allCategories
          .map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(
                value.toString(),
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _appBarSearchForm() {
    return TextField(
      style: const TextStyle(color: Colors.white, fontSize: 18),
      autofocus: true,
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: 'Enter a title',
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
      ),
      onChanged: (value) {
        setState(() {
          kw = value;
          _getfiltredTasks();
        });
      },
    );
  }

  Future<void> _loadCategories() async {
    final loadedCategories = await dbHelper.getAllCategories();
    setState(() {
      allCategories = loadedCategories;
      selectedCategory =
          allCategories.isNotEmpty ? allCategories.first : TCategory();
    });
  }

  Future<void> _loadData() async {
    final loadedTasks = await dbHelper.getAllTasks();
    setState(() {
      tasks = loadedTasks;
      _getfiltredTasks();
    });
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    await dbHelper.changeTaskCompletion(task);
    _loadData();
  }

  Future<void> _deleteTask(Task task) async {
    await dbHelper.deleteTask(task.id!);
    _loadData();
  }

  void _navigateToAddTaskScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    ).then((categoryAddedTask) => {
          _callBack(categoryAddedTask),
        });
  }

  void _callBack(catId) async {
    _loadCategories();
    tasks = await dbHelper.getAllTasks();
    setState(() {
      if (catId != null &&
          selectedCategory != null &&
          selectedCategory?.id != null) {
        selectedCategory = allCategories.firstWhere((e) => e.id == catId);
      }
      _getfiltredTasks();
    });
  }

  void _navigateToEditTaskScreen(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );
    _loadData();
  }

  Future<void> _getfiltredTasks() async {
    setState(() {
      filteredTasks = searchRound
          ? tasks
              .where((e) => e.title!.toLowerCase().contains(kw.toLowerCase()))
              .toList()
          : tasks.where((e) => e.category!.id == selectedCategory?.id).toList();
    });
  }
}
