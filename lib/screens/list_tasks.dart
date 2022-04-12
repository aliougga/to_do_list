import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:to_do_list/models/category.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/theme/colors/light_colors.dart';
import '../utils/dbhelper.dart';

class ListTasks extends StatefulWidget {
  const ListTasks({Key? key}) : super(key: key);
  @override
  State<ListTasks> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  Color color = const Color(0x002d7061);
  Color color2 = const Color(0x00bad1cc);
  final dbHelper = DatabaseHelper.instance;
  Category? dropdownValue;

  //List<String> spinnerItems = ['My Tasks', 'Ended tasks'];
  List<Category>? spinnerItems;
  int _idCategory = 1;
  FocusNode dropDownNode = FocusNode();

  bool isAppbarSearch = false;
  Icon actionIcon = const Icon(Icons.search);

  //Mot clé
  String mc = "";
  List<Task>? tasksByTitle;

  @override
  void initState() {
    // pressToDelete = false;
    _getListCategories();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
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
        title: isAppbarSearch
            ? TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: "Recherche...",
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: LightColors.kGreen),
                  ),
                  focusedBorder: UnderlineInputBorder(
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
              )
            : _getDropdown(),
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(
                () {
                  if (actionIcon.icon == Icons.search) {
                    actionIcon = const Icon(Icons.close);
                    isAppbarSearch = true;
                  } else {
                    actionIcon = const Icon(Icons.search);
                    mc = "";
                    isAppbarSearch = false;
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Task>>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: LightColors.kGreen,
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(
                      child: Text("Échec de la connexion..."),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("Liste de tâches vide..."),
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.task,
                          color: Colors.grey,
                          size: 90.0,
                        ),
                        Text(
                          "Liste vide, ajoutez vos tâches\n en appuyant sur le bouton +",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              !snapshot.data![index].isTaskDone!
                                  ? _widgetCheckBox(
                                      snapshot.data![index].isTaskDone!,
                                      snapshot.data![index])
                                  : Container(),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].taskTitle!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      _dateFormatJMA(
                                          snapshot.data![index].taskDate!
                                          //snapshot.data![index].taskTime!
                                          ),
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: _isPassed(snapshot
                                                  .data![index].taskDate!)
                                              ? Colors.red
                                              : Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              snapshot.data![index].isTaskDone!
                                  ? _widgetDelete(snapshot.data![index].taskId)
                                  : Container(),
                            ],
                          ),
                          autofocus: false,
                          dense: true,
                        ),
                        color: LightColors.kVGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      );
                    },
                  );
                },
                future: _queryByTitle(mc),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: const CircleAvatar(
                    backgroundColor: LightColors.kWhite,
                    radius: 30,
                    child: Icon(
                      Icons.add,
                      color: LightColors.kGreen,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/form').then((value) {
                    setState(() {});
                  });
                },
              ),
            ),
          ),
        ],
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
      return "aucune date";
    } else {
      var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
      DateFormat dateFormatFInal = DateFormat.MMMMEEEEd(tag);

      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime date = dateFormat.parse(dateStr);
      final now = DateTime.now();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      if (tomorrow.day == date.day &&
          tomorrow.month == date.month &&
          tomorrow.year == date.year) {
        return "demain";
      } else if (now.day == date.day &&
          now.month == date.month &&
          now.year == date.year) {
        return "aujourd'hui";
      } else if (yesterday.day == date.day &&
          yesterday.month == date.month &&
          yesterday.year == date.year) {
        return "hier";
      } else {
        return dateFormatFInal.format(date);
      }
    }
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
        dropdownValue = newValue!;
        _idCategory = newValue.categryId!;
        setState(() {});
      },
      items: spinnerItems
          ?.map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(value.toString()),
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
  void _markAsDone(Task t) async {
    // row to update
    t.isTaskDone = true;
    t.myCategory = 2;
    await dbHelper.update(t);
    _showMessageInScaffold('${t.taskTitle} fait !');
  }

  ///Supprimer un task ddont on passe l'id est passé en paramettre
  void _deleteTask(id) async {
    await dbHelper.delete(id);
    _showMessageInScaffold('Tâche supprimée !');
  }

  ///Boutton de suppression
  Widget _widgetDelete(id) {
    return GestureDetector(
      child: const Icon(
        Icons.delete,
      ),
      onTap: () {
        setState(() {
          _deleteTask(id);
        });
      },
    );
  }

  ///Case à cocher
  Widget _widgetCheckBox(val, data) {
    return Checkbox(
      value: val,
      onChanged: (value) {
        setState(() {
          _markAsDone(data);
        });
      },
      checkColor: LightColors.kGreen,
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
