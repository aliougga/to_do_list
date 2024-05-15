import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryItem extends StatelessWidget {
  final TCategory category;
  final Function() onTap;

  const CategoryItem({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.name!),
      onTap: onTap,
    );
  }
}
