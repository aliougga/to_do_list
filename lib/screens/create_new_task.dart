import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/theme/colors/light_colors.dart';
import '../utils/dbhelper.dart';

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({Key? key}) : super(key: key);

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final dbHelper = DatabaseHelper.instance;

  //Les variables pour la gestion des categories
  // List<Category>? spinnerItems;
  // int _idCategory = 1;
  //Category? dropdownValue;

  ///Debut des variable pour la gestion des date
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  TimeOfDayFormat timeOfDayFormat = TimeOfDayFormat.HH_colon_mm;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  ///Debut des controller pour les TextField
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerTitre = TextEditingController();

  ///Pour gerer le focus du TextField du titre le focus est active tantque le champ est vide
  FocusNode nodeTitle = FocusNode();
  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
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
        title: const Text(
          "Nouvelle tâche",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Qu'allez-vous faire ?",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        TextField(
                          focusNode: nodeTitle,
                          cursorColor: LightColors.kGreen,
                          cursorHeight: 30,
                          decoration: const InputDecoration(
                            hintText: "Entrez le titre",
                            hoverColor: LightColors.kGreen,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: LightColors.kGreen),
                            ),
                            focusedBorder: UnderlineInputBorder(
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
                                  "Veuillez saisir le titre");
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
                        const Text(
                          "Quand ?",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                                  decoration: const InputDecoration(
                                    hintText: "Sélectionnez une date",
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
                              locale: const Locale("fr", "FR"),
                            );

                            if (tempoDate != null) {
                              setState(
                                () {
                                  controllerDate.text =
                                      dateFormat.format(tempoDate);
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
                        //     // const SizedBox(height: 40.0),
                        //     // const Text(
                        //     //   "Select categorie",
                        //     //   style: TextStyle(
                        //     //       fontSize: 18, fontWeight: FontWeight.bold),
                        //     //   textAlign: TextAlign.left,
                        //     // ),
                        //     // Row(
                        //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     //   children: [
                        //     //     _getDropdown(),
                        //     //     GestureDetector(
                        //     //       child: const CircleAvatar(
                        //     //         backgroundColor: LightColors.kGreen,
                        //     //         radius: 20.0,
                        //     //         child: Icon(
                        //     //           Icons.add,
                        //     //           size: 20.0,
                        //     //           color: LightColors.kWhite,
                        //     //         ),
                        //     //       ),
                        //     //       onTap: () async {
                        //     //         var startTempo = await showTimePicker(
                        //     //             context: context,
                        //     //             initialTime: selectedTime);
                        //     //         if (startTempo != null) {
                        //     //           controllerTime.text =
                        //     //               formatTimeOfDay(startTempo);
                        //     //         }
                        //     //       },
                        //     //     ),
                        //     //   ],
                        //     // ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: const CircleAvatar(
                    backgroundColor: LightColors.kWhite,
                    radius: 30,
                    child: Icon(
                      Icons.check,
                      color: LightColors.kGreen,
                    ),
                  ),
                ),
                onTap: () {
                  if (controllerTitre.text.isEmpty) {
                    FocusScope.of(context).requestFocus(nodeTitle);
                    _showMessageInScaffold("Veuillez saisir le titre.");
                  } else {
                    _insertTask(controllerTitre.text, controllerDate.text,
                        controllerTime.text, "0");
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _getListCategories() async {
  //   final allRows = await dbHelper.queryAllCategory();
  //   spinnerItems = <Category>[];
  //   for (var row in allRows) {
  //     spinnerItems!.add(
  //       Category.fromMap(row),
  //     );
  //   }
  //   setState(() {
  //     dropdownValue = spinnerItems!.first;
  //   });
  // }

  void _insertTask(title, date, time, isDone) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.taskTitle: title,
      DatabaseHelper.taskDate: date,
      DatabaseHelper.taskTime: time,
      DatabaseHelper.taskDone: isDone,
    };
    Task t = Task.fromMap(row);
    await dbHelper.insert(t);
    _showMessageInScaffold('Tâche ajoutée');
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

  // Widget _getDropdown() {
  //   return DropdownButton<Category>(
  //     value: dropdownValue,
  //     icon: const Icon(Icons.arrow_drop_down, color: LightColors.kGreen),
  //     iconSize: 24,
  //     isExpanded: false,
  //     focusColor: LightColors.kVGrey,
  //     style: const TextStyle(color: LightColors.kGreen, fontSize: 20),
  //     dropdownColor: LightColors.kVGrey,
  //     onChanged: (newValue) {
  //       setState(() {
  //         dropdownValue = newValue!;
  //      //   _idCategory = newValue.categryId!;
  //       });
  //     },
  //     items: spinnerItems
  //         ?.map(
  //           (value) => DropdownMenuItem(
  //             value: value,
  //             child: Text(value.toString()),
  //           ),
  //         )
  //          .toList(),
  //   );
  // }
}
