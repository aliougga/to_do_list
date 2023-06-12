import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/theme/colors/light_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/category.dart';
import '../../utils/dbhelper.dart';

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({Key? key}) : super(key: key);

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  //Ads variable
  //late BannerAd _ad;
  //late bool _isAdLoaded = false;

  final dbHelper = DatabaseHelper.instance;

  //Les variables pour la gestion des categories
  List<Category>? spinnerItems;
  int _idCategory = 1;
  Category? dropdownValue;

  ///Debut des variable pour la gestion des date
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  TimeOfDayFormat timeOfDayFormat = TimeOfDayFormat.HH_colon_mm;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  ///Debut des controller pour les TextField
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerTitre = TextEditingController();
  TextEditingController controllerNomCategorie = TextEditingController();

  //Pour gérer le focus du TextField du titre le focus est active tant que le champ est vide
  FocusNode nodeTitle = FocusNode();
  FocusNode nodeNomCategorie = FocusNode();

  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    _getListCategories(1);

    //Ads initialization
    // _ad = BannerAd(
    //   adUnitId: AdHelper.banner2AdUnitId,
    //   size: AdSize.banner,
    //   request: const AdRequest(),
    //   listener: BannerAdListener(
    //     onAdLoaded: (_) {
    //       setState(() {
    //         _isAdLoaded = true;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, error) {
    //       // Releases an ad resource when it fails to load
    //       ad.dispose();
    //     },
    //   ),
    // );

    //_ad.load();
    super.initState();
  }

  /// Formatter l'heure issue de DatePicker en String
  // String formatTimeOfDay(TimeOfDay tod) {
  //   final now = DateTime.now();
  //   final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  //   final format = DateFormat.Hm(); //"6:00 AM"
  //   return format.format(dt);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.addTask,
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //titre
                  Text(
                    AppLocalizations.of(context)!.labelFieldTitle,
                    style: const TextStyle(
                        fontSize: 18, color: LightColors.kGreen),
                    textAlign: TextAlign.left,
                  ),
                  TextField(
                    focusNode: nodeTitle,
                    cursorColor: LightColors.kGreen,
                    cursorHeight: 30,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.hintFieldTitle,
                      hoverColor: LightColors.kGreen,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: LightColors.kGreen),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: LightColors.kGreen,
                        ),
                      ),
                    ),
                    controller: controllerTitre,
                    onSubmitted: (value) {
                      if (value.isEmpty) {
                        FocusScope.of(context).requestFocus(nodeTitle);
                        _showMessageInScaffold(
                            AppLocalizations.of(context)!.titleFieldErrMsg);
                      } else {
                        controllerTitre.text = value;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.labelFieldDate,
                    style: const TextStyle(
                        fontSize: 18, color: LightColors.kGreen),
                    textAlign: TextAlign.left,
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: controllerDate,
                            enabled: false,
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.hintFieldDate,
                            ),
                          ),
                        ),
                        const CircleAvatar(
                          backgroundColor: LightColors.kGreen,
                          radius: 20.0,
                          child: Icon(
                            Icons.calendar_today,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      var tempoDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2100),
                        locale:
                            Locale(AppLocalizations.of(context)!.localCalender),
                      );
                      if (tempoDate != null) {
                        setState(
                          () {
                            controllerDate.text = dateFormat.format(tempoDate);
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Text(
                  //       "À quelle heure ?",
                  //       style: TextStyle(
                  //           fontSize: 18, fontWeight: FontWeight.bold),
                  //       textAlign: TextAlign.left,
                  //     ),
                  //     GestureDetector(
                  //       child: Row(
                  //         mainAxisAlignment:
                  //             MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Expanded(
                  //             child: TextField(
                  //               controller: controllerTime,
                  //               enabled: false,
                  //               decoration: const InputDecoration(
                  //                   hintText: "Heure de début",
                  //                   focusedBorder: UnderlineInputBorder(
                  //                       borderSide: BorderSide(
                  //                           color: Colors.black)),
                  //                   border: UnderlineInputBorder(
                  //                       borderSide: BorderSide(
                  //                           color: Colors.grey))),
                  //             ),
                  //           ),
                  //           const CircleAvatar(
                  //             backgroundColor: LightColors.kGreen,
                  //             radius: 20.0,
                  //             child: Icon(
                  //               Icons.watch_later,
                  //               size: 20.0,
                  //               color: LightColors.kWhite,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       onTap: () async {
                  //         var startTempo = await showTimePicker(
                  //             context: context,
                  //             initialTime: selectedTime);
                  //         if (startTempo != null) {
                  //           controllerTime.text =
                  //               formatTimeOfDay(startTempo);
                  //         }
                  //       },
                  //     ),
                  const SizedBox(height: 40.0),
                  Text(
                    AppLocalizations.of(context)!.labelFieldCategory,
                    style: const TextStyle(
                        fontSize: 18, color: LightColors.kGreen),
                    textAlign: TextAlign.left,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _getDropdown(),
                      GestureDetector(
                        child: const CircleAvatar(
                          backgroundColor: LightColors.kGreen,
                          radius: 20.0,
                          child: Icon(
                            Icons.add,
                            size: 20.0,
                            color: LightColors.kWhite,
                          ),
                        ),
                        onTap: () async {
                          _getModal();
                        },
                      ),
                    ],
                  ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: LightColors.kWhite,
        onPressed: (() {
          if (controllerTitre.text.isEmpty) {
            FocusScope.of(context).requestFocus(nodeTitle);
            _showMessageInScaffold(
                AppLocalizations.of(context)!.titleFieldErrMsg);
          } else {
            _insertTask(controllerTitre.text, controllerDate.text,
                controllerTime.text, "0", _idCategory);
            Navigator.pop(context, _idCategory);
          }
        }),
        child: const Icon(
          Icons.check,
          color: LightColors.kGreen,
        ),
      ),
    );
  }

  _getListCategories(int rang) async {
    final allRows = await dbHelper.queryAllCategoryActives();
    spinnerItems = <Category>[];
    for (var row in allRows) {
      spinnerItems!.add(
        Category.fromMap(row),
      );
    }

    if (rang == 0) {
      setState(() {
        dropdownValue = spinnerItems!.last;
      });
    } else {
      setState(() {
        dropdownValue = spinnerItems!.first;
      });
    }
  }

  void _insertTask(title, date, time, isDone, idc) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.taskTitle: title,
      DatabaseHelper.taskDate: date,
      DatabaseHelper.taskTime: time,
      DatabaseHelper.taskDone: isDone,
    };
    Task t = Task.fromMap(row);
    await dbHelper.insert(t, idc);
    _showMessageInScaffold(AppLocalizations.of(context)!.taskAddedMsg);
  }

  // void _insertCategory(title, date, time, isDone) async {
  //   // row to insert
  //   Map<String, dynamic> row = {
  //     DatabaseHelper.taskTitle: title,
  //     DatabaseHelper.taskDate: date,
  //     DatabaseHelper.taskTime: time,
  //     DatabaseHelper.taskDone: isDone,
  //   };
  //   Task t = Task.fromMap(row);
  //   final id = await dbHelper.insert(t);
  //   _showMessageInScaffold('inserted row id: $id');
  // }

  // Future<Category?> _getCategorieById(id) async {
  //   return await dbHelper.queryOneCategory(id);
  // }

  Widget _getDropdown() {
    return DropdownButton<Category>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down, color: LightColors.kGreen),
      iconSize: 24,
      isExpanded: false,
      focusColor: LightColors.kVGrey,
      style: const TextStyle(color: LightColors.kGreen, fontSize: 20),
      dropdownColor: LightColors.kVGrey,
      onChanged: (newValue) {
        dropdownValue = newValue!;
        _idCategory = newValue.categryId!;
        setState(() {});
      },
      items: spinnerItems
          ?.map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(
                value.toString(),
                style: const TextStyle(
                    fontFamily: 'Poppins', color: Colors.black54),
              ),
            ),
          )
          .toList(),
    );
  }

  _getModal() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Form(
              // key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      focusNode: nodeNomCategorie,
                      controller: controllerNomCategorie,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.nameCatLabel),
                      onSubmitted: (value) {
                        if (value.isEmpty) {
                          FocusScope.of(context).requestFocus(nodeNomCategorie);
                          _showMessageInScaffold(
                              AppLocalizations.of(context)!.nameCatErrMsg);
                        } else {
                          controllerNomCategorie.text = value;
                        }
                      }),
                ],
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.addCategory,
              style: const TextStyle(color: LightColors.kGreen),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      child: Text(AppLocalizations.of(context)!.cancelButton),
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      child: Text(
                        AppLocalizations.of(context)!.addButton,
                        style: const TextStyle(color: LightColors.kGreen),
                      ),
                      onTap: () async {
                        if (controllerNomCategorie.text.isEmpty) {
                          FocusScope.of(context).requestFocus(nodeNomCategorie);
                          _showMessageInScaffold(
                              AppLocalizations.of(context)!.nameCatErrMsg);
                        } else {
                          await _newCategorie(controllerNomCategorie.text);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  _newCategorie(str) async {
    Category c = Category(categoryName: str);
    _idCategory = await dbHelper.insertCat(c);
    _getListCategories(0);
    setState(() {});
  }
}
