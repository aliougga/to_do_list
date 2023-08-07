// import 'package:flutter/material.dart';

// import 'screens/home_screen.dart';
// import 'screens/task_details_screen.dart';
// import 'screens/add_task_screen.dart';
// import 'screens/edit_task_screen.dart';
// import 'screens/category_screen.dart';
// import 'screens/edit_category_screen.dart';

// class AppRouter {
//   static Route<dynamic>? generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => HomeScreen());
//       case '/task-details':
//         if (settings.arguments is String) {
//           final taskId = settings.arguments as String;
//           return MaterialPageRoute(builder: (_) => TaskDetailsScreen(taskId: taskId));
//         }
//         return _errorRoute();
//       case '/add-task':
//         return MaterialPageRoute(builder: (_) => AddTaskScreen());
//       case '/edit-task':
//         if (settings.arguments is String) {
//           final taskId = settings.arguments as String;
//           return MaterialPageRoute(builder: (_) => EditTaskScreen(taskId: taskId));
//         }
//         return _errorRoute();
//       case '/category':
//         return MaterialPageRoute(builder: (_) => CategoryScreen());
//       case '/edit-category':
//         if (settings.arguments is String) {
//           final categoryId = settings.arguments as String;
//           return MaterialPageRoute(builder: (_) => EditCategoryScreen(categoryId: categoryId));
//         }
//         return _errorRoute();
//       default:
//         return _errorRoute();
//     }
//   }

//   static Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(builder: (_) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Error'),
//         ),
//         body: Center(
//           child: Text('Page not found'),
//         ),
//       );
//     });
//   }
// }
