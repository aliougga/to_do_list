import 'package:flutter/material.dart';
import 'package:to_do_list/models/category.dart';
import 'package:to_do_list/widgets/category_item.dart';
import '../services/db_helper.dart';
import 'add_category_screen.dart';
import 'edit_category_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<TCategory> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            //    trailing: CircleAvatar(backgroundColor: category.color,),
            title: Dismissible(
              key: Key(category.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (_) => _deleteCategory(category),
              child: CategoryItem(
                category: category,
                onTap: () => _navigateToEditCategoryScreen(category),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddCategoryScreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _loadCategories() async {
    final loadedCategories = await dbHelper.getAllCategories();
    setState(() {
      categories = loadedCategories;
    });
  }

  Future<void> _deleteCategory(TCategory category) async {
    await dbHelper.deleteCategory(category.id!);
    _loadCategories();
  }

  void _navigateToAddCategoryScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCategoryScreen(),
      ),
    );
    _loadCategories();
  }

  void _navigateToEditCategoryScreen(TCategory category) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryScreen(category: category),
      ),
    );
    _loadCategories();
  }
}
