import 'package:to_do_list/utils/dbhelper.dart';

class Category {
  int? categryId;
  String? categoryName;

  Category({this.categryId, this.categoryName});

  Category.fromMap(Map<String, dynamic> map) {
    categryId = map['id_category'];
    categoryName = map['name_category'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.categoryId: categryId,
      DatabaseHelper.categoryName: categoryName,
    };
  }

  @override
  String toString() {
    return categoryName!;
  }
}
