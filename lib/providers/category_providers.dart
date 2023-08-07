import 'package:flutter/foundation.dart';

import '../models/category.dart';


class CategoryProvider with ChangeNotifier {
 final List<TCategory> _categories = [];

  List<TCategory> get categories => _categories;

  void addCategory(TCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(TCategory updatedCategory) {
    final index = _categories.indexWhere((category) => category.id == updatedCategory.id);
    if (index >= 0) {
      _categories[index] = updatedCategory;
      notifyListeners();
    }
  }

  void deleteCategory(String categoryId) {
    _categories.removeWhere((category) => category.id == categoryId as int);
    notifyListeners();
  }
}
