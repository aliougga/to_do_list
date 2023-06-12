import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:to_do_list/models/category.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/theme/colors/light_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/dbhelper.dart';

class ListTasks extends StatefulWidget {
  const ListTasks({Key? key}) : super(key: key);
  @override
  State<ListTasks> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  bool _isAppbarSearch = false;

  Color color = const Color(0x002d7061);
  Color color2 = const Color(0x00bad1cc);
  final dbHelper = DatabaseHelper.instance;
  Category? dropdownValue;

  //List<String> spinnerItems = ['My Tasks', 'Ended tasks'];
  List<Category>? spinnerItems;
  int _idCategory = 1;
  FocusNode dropDownNode = FocusNode();

  //ID that will be delete
  int _idToUpdateOrDelete = -1;

  //Mot clé
  String mc = "";
  List<Task>? tasksByTitle;

  @override
  void initState() {
    // pressToDelete = false;
    _getListCategories();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateMyApp.init();
      if (mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(context);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isAppbarSearch ? _appBarSearchForm() : _getDropdown(),
        actions: [
          _isAppbarSearch
              ? IconButton(
                  icon: const Icon(Icons.close_outlined),
                  onPressed: () {
                    setState(() {
                      mc = "";
                      _isAppbarSearch = false;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search_outlined),
                  onPressed: () {
                    setState(
                      () {
                        _isAppbarSearch = true;
                      },
                    );
                  },
                ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.task,
                      color: Colors.grey,
                      size: 90.0,
                    ),
                    Text(
                      AppLocalizations.of(context)!.emptyListLongMsg,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            }
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onLongPress: () async {
                      _modalActionsMenu(snapshot.data![index]);
                    },
                    trailing: snapshot.data![index].isTaskDone!
                        ? GestureDetector(
                            child: const Icon(
                              Icons.delete_outline,
                            ),
                            onTap: () {
                              setState(() {
                                _deleteTask(snapshot.data![index].taskId!);
                              });
                            },
                          )
                        : GestureDetector(
                            child: const Icon(Icons.more_vert),
                            onTap: () async {
                              _modalActionsMenu(snapshot.data![index]);
                            },
                          ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data![index].taskTitle!,
                          style: TextStyle(
                            fontSize: 18,
                            decoration: snapshot.data![index].isTaskDone!
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        Text(
                          _dateFormatJMA(snapshot.data![index].taskDate!
                              //snapshot.data![index].taskTime!
                              ),
                          style: TextStyle(
                              fontSize: 13,
                              color: _isPassed(snapshot.data![index].taskDate!)
                                  ? Colors.red
                                  : Colors.black),
                        ),
                      ],
                    ),
                  );
                }
                // },
                );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: _queryByTitle(mc),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: LightColors.kGreen,
        ),
        backgroundColor: LightColors.kWhite,
        onPressed: () {
          Navigator.pushNamed(context, '/form')
              // ignore: avoid_print
              .then((v) => _onBack(v));
        },
      ),
    );
  }

  ///Verifer si la date est passé, utilisé pour ecrire les date passé en rouge
  bool _isPassed(String from) {
    if (from.isEmpty) {
      return true;
    } else {
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime date = dateFormat.parse(from);
      String strNow = dateFormat.format(DateTime.now());
      DateTime now = dateFormat.parse(strNow);
      if (now.compareTo(date) > 0) {
        return true;
      } else {
        return false;
      }
    }
  }

  ///Formattage de date de String de la base en date
  _dateFormatJMA(String dateStr) {
    if (dateStr.trim().isEmpty) {
      return AppLocalizations.of(context)!.noDate;
    } else {
      var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
      DateFormat dateFormatFInal = DateFormat.yMMMMEEEEd(tag);

      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime date = dateFormat.parse(dateStr);
      final now = DateTime.now();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      if (tomorrow.day == date.day &&
          tomorrow.month == date.month &&
          tomorrow.year == date.year) {
        return AppLocalizations.of(context)!.tomorrow;
      } else if (now.day == date.day &&
          now.month == date.month &&
          now.year == date.year) {
        return AppLocalizations.of(context)!.today;
      } else if (yesterday.day == date.day &&
          yesterday.month == date.month &&
          yesterday.year == date.year) {
        return AppLocalizations.of(context)!.tomorrow;
      } else {
        return dateFormatFInal.format(date);
      }
    }
  }

//formulaire de recherche dans l'appBar
  Widget _appBarSearchForm() {
    return TextField(
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        hintText: AppLocalizations.of(context)!.searchLabel,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: LightColors.kGreen),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: LightColors.kGreen,
          ),
        ),
      ),
      onChanged: (value) {
        setState(() {
          mc = value;
        });
      },
    );
  }

  ///Retourne le menu des categories
  Widget _getDropdown() {
    return DropdownButton<Category>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      iconSize: 24,
      isExpanded: false,
      focusColor: LightColors.kVGrey,
      style: const TextStyle(color: Colors.white, fontSize: 20),
      dropdownColor: LightColors.kGreen,
      onChanged: (newValue) {
        setState(() {
          dropdownValue = newValue!;
          _idCategory = newValue.categryId!;
        });
      },
      items: spinnerItems
          ?.map(
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

  ///Toast
  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  ///Pour charger la liste des categories
  void _getListCategories() async {
    final allRows = await dbHelper.queryAllCategory();
    spinnerItems = <Category>[];
    for (var row in allRows) {
      spinnerItems!.add(
        Category.fromMap(row),
      );
    }
    setState(() {
      dropdownValue = spinnerItems!.first;
    });
  }

  ///Select task by mot clé
  Future<List<Task>> _queryByTitle(name) async {
    final allRows = await dbHelper.queryRows(name, _idCategory);
    List<Task> list = <Task>[];
    for (var row in allRows) {
      list.add(
        Task.fromMap(row),
      );
    }
    return list;
  }

  ///Marqué la task comme fait ainsi son idCategory est passé à 2 pour cette version
  Future<void> _markAsDone(Task t) async {
    // row to update
    t.isTaskDone = true;
    t.myCategory = 2;
    await dbHelper.update(t);
    _showMessageInScaffold(
        '${t.taskTitle}  ${AppLocalizations.of(context)!.doneMsg}');

    setState(() {});
  }

  ///Supprimer un task ddont on passe l'id est passé en paramettre
  Future<void> _deleteTask(id) async {
    await dbHelper.delete(id);
    _showMessageInScaffold(AppLocalizations.of(context)!.deletedMsg);

    setState(() {});
  }

  _onBack(v) async {
    _idCategory = v;

    final allRows = await dbHelper.queryAllCategory();
    spinnerItems = <Category>[];
    for (var row in allRows) {
      spinnerItems!.add(
        Category.fromMap(row),
      );
    }

    setState(() {
      dropdownValue =
          spinnerItems!.firstWhere((element) => element.categryId == v);
    });
  }
  
  _modalActionsMenu(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Marquez comme fait'),
              onTap: () async {
                await _markAsDone(task);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Supprimer'),
              onTap: () async {
                Navigator.of(context).pop();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Confirmation"),
                      content: const Text(
                          "Voulez-vous vraiment supprimer cette tâche ?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            await _deleteTask(task.taskId);
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Supprimer',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'Nous évaluer',
  minDays: 0,
  minLaunches: 3,
  remindDays: 2,
  remindLaunches: 7,
  googlePlayIdentifier: 'com.alga.to_do_list',
);
