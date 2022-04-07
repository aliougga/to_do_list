import 'package:flutter/material.dart';
import 'package:to_do_list/screens/create_new_task.dart';
import 'package:to_do_list/screens/list_tasks.dart';
import 'package:to_do_list/theme/theme.dart';

void main() {
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme1,
      title: 'List task',
      initialRoute: '/',
      routes: {
        '/list': (context) => const ListTasks(),
        '/form': (context) => const CreateNewTask(),
      },
      home: const ListTasks(),
      debugShowCheckedModeBanner: false,
    );
  }
}
