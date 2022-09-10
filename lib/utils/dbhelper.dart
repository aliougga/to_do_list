import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/models/category.dart';
import 'package:to_do_list/models/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_list/utils/navigator_context.dart';

class DatabaseHelper {
  static const _databaseName = "taskdb.db";
  static const _databaseVersion = 2;

  // task table
  static const tableTask = 'task';
  static const taskId = 'id';
  static const taskTitle = 'title';
  static const taskDate = 'date';
  static const taskTime = 'time';
  static const taskDone = 'is_done';
  static const taskCategory = 'my_category';

  static const tableCategory = 'category';
  static const categoryId = 'id_category';
  static const categoryName = 'name_category';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDatabase();
      return _database;
    } // lazily instantiate the db the first time it is accessed
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute(" CREATE TABLE $tableTask ("
            "$taskId INTEGER PRIMARY KEY AUTOINCREMENT,"
            " $taskTitle TEXT NOT NULL,"
            " $taskDone INTEGER NOT NULL,"
            " $taskDate TEXT,"
            "$taskTime TEXT,"
            "$taskCategory INTEGER NOT NULL DEFAULT 1)");

        await db.execute(" CREATE TABLE $tableCategory ("
            "$categoryId INTEGER PRIMARY KEY AUTOINCREMENT,"
            "$categoryName TEXT NOT NULL)");

        db.insert(tableCategory, {
          categoryId: 1,
          categoryName: AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .catDefault
        });
        db.insert(tableCategory, {
          categoryId: 2,
          categoryName: AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .catEnded
        });
        db.insert(tableCategory, {
          categoryName: AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .catJobs
        });
        db.insert(tableCategory, {
          categoryName: AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .catCourses
        });
        db.insert(tableCategory, {
          categoryName: AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .catSport
        });
      },
    );
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Task t, idc) async {
    Database? db = await instance.database;
    return await db!.insert(tableTask, {
      taskTitle: t.taskTitle,
      taskDate: t.taskDate,
      taskTime: t.taskTime,
      taskDone: t.isTaskDone,
      taskCategory: idc
    });
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(tableTask);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(title, cat) async {
    Database? db = await instance.database;
    return await db!.query(
      tableTask,
      where: "$taskTitle LIKE '%$title%' AND $taskCategory = $cat",
      orderBy: taskDate,
    );
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
      await db!.rawQuery('SELECT COUNT(*) FROM $tableTask ORDER BY $taskDate'),
    );
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Task t) async {
    Database? db = await instance.database;
    int id = t.toMap()[taskId];
    return await db!.update(
      tableTask,
      t.toMap(),
      where: '$taskId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(
      tableTask,
      where: '$taskId = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertCategory(Category c) async {
    Database? db = await instance.database;
    return await db!.insert(tableCategory, {
      categoryName: c.categoryName,
    });
  }

  Future<List<Map<String, dynamic>>> queryAllCategory() async {
    Database? db = await instance.database;
    return await db!.query(
      tableCategory,
      orderBy: categoryId,
    );
  }

  Future<List<Map<String, dynamic>>> queryAllCategoryActives() async {
    Database? db = await instance.database;
    return await db!.query(
      tableCategory,
      where: '$categoryId != ?',
      whereArgs: [2],
    );
  }

  // Future<Category>? queryOneCategory(id) async {
  //   Database? db = await instance.database;
  //   List<Map<String, dynamic>> rs = await db!.query(
  //     tableCategory,
  //     where: '$categoryId != ?',
  //     whereArgs: [id]);

  //     return Category.fromMap(rs.first);
  // }

  Future<int> insertCat(Category c) async {
    Database? db = await instance.database;
    return await db!.insert(tableCategory, {
      categoryName: c.categoryName,
    });
  }
}
