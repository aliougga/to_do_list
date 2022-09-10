import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:to_do_list/models/category.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/theme/colors/light_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils/ad_helper.dart';
import '../../utils/dbhelper.dart';

class ListTasks extends StatefulWidget {
  const ListTasks({Key? key}) : super(key: key);
  @override
  State<ListTasks> createState() => _ListTasksState();
}

class _ListTasksState extends State<ListTasks> {
  //Ads variable
  late BannerAd _ad;
  late bool _isAdLoaded = false;
  static const _kAdIndex = 4;

  // 0 pour default, 1 pour recherche, 2 pour update
  int _appBarRound = 0;

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

  //L'AppBar
  late AppBar _myAppBar;
  //Mot clé
  String mc = "";
  List<Task>? tasksByTitle;

  AppBar _customAppBar(title, actions) {
    return AppBar(
      title: title,
      actions: [
        actions!,
      ],
    );
  }

  AppBar _customAppBarWithLeading(actions, leading) {
    return AppBar(
      actions: [actions],
      leading: leading,
    );
  }

  @override
  void initState() {
    // pressToDelete = false;
    _getListCategories();
    _myAppBar = _customAppBar(
      _getDropdown(),
      _defaultAppBarAction(),
    );

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await rateMyApp.init();
      if (mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(context);
      }
    });

    //Ads initialization
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
        },
      ),
    );
    _ad.load();
    super.initState();
  }

  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _myAppBar,
      body: Padding(
        padding: const EdgeInsets.all(2.0),
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
              return Center(
                child: Text(AppLocalizations.of(context)!.failConnMsg),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: Text(AppLocalizations.of(context)!.emptyListMsg),
              );
            }
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
              ));
            }

            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_isAdLoaded && index == _kAdIndex) {
                    return Container(
                      child: AdWidget(ad: _ad),
                      height: 80.0,
                      alignment: Alignment.center,
                    );
                  } else {
                    final int newIndex = _getDestinationItemIndex(index);
                    return InkWell(
                      child: ListTile(
                        selectedColor: LightColors.kGreen,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            !snapshot.data![newIndex].isTaskDone!
                                ? _widgetCheckBox(
                                    snapshot.data![newIndex].isTaskDone!,
                                    snapshot.data![newIndex])
                                : Container(),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![newIndex].taskTitle!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      decoration:
                                          snapshot.data![newIndex].isTaskDone!
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    _dateFormatJMA(
                                        snapshot.data![newIndex].taskDate!
                                        //snapshot.data![index].taskTime!
                                        ),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: _isPassed(snapshot
                                                .data![newIndex].taskDate!)
                                            ? Colors.red
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            snapshot.data![newIndex].isTaskDone!
                                ? _widgetDelete(snapshot.data![newIndex].taskId)
                                : Container(),
                          ],
                        ),
                        autofocus: false,
                        dense: true,
                      ),
                      onTap: () {
                        setState(() {
                          _myAppBar = _customAppBar(
                            _getDropdown(),
                            _defaultAppBarAction(),
                          );
                        });
                      },
                      onLongPress: () {
                        if (!snapshot.data![newIndex].isTaskDone!) {
                          setState(() {
                            _idToUpdateOrDelete =
                                snapshot.data![newIndex].taskId!;
                            _myAppBar = _customAppBarWithLeading(
                              _widgetDelete(_idToUpdateOrDelete),
                              _udateAppBarAction(),
                            );
                          });
                        }
                      },
                    );
                  }
                },
              );
            }

            return Container();
          },
          future: _queryByTitle(mc),
        ),
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
  void _markAsDone(Task t) async {
    // row to update
    t.isTaskDone = true;
    t.myCategory = 2;
    await dbHelper.update(t);
    _showMessageInScaffold(
        '${t.taskTitle}  ${AppLocalizations.of(context)!.doneMsg}');
  }

  ///Supprimer un task ddont on passe l'id est passé en paramettre
  void _deleteTask(id) async {
    await dbHelper.delete(id);
    _showMessageInScaffold(AppLocalizations.of(context)!.deletedMsg);
  }

  ///Boutton de suppression
  Widget _widgetDelete(id) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        child: const Icon(
          Icons.delete_outline,
        ),
        onTap: () {
          setState(() {
            _deleteTask(id);
            _myAppBar = _customAppBar(
              _getDropdown(),
              _defaultAppBarAction(),
            );
          });
        },
      ),
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
      _myAppBar = _customAppBar(
        _getDropdown(),
        _defaultAppBarAction(),
      );
    });

    // dropdownValue = await dbHelper.queryOneCategory(v);
    // _getListCategories();
    //_queryByTitle(mc);
    //setState(() {});
  }

  //Modifier les information d'une tache
  // _onClickToUpdate() {}

  Widget _defaultAppBarAction() {
    return IconButton(
      icon: const Icon(Icons.search_outlined),
      onPressed: () {
        setState(
          () {
            _myAppBar = _customAppBar(
              _appBarSearchForm(),
              _searchAppBarAction(),
            );
          },
        );
      },
    );
  }

  Widget _searchAppBarAction() {
    return IconButton(
      icon: const Icon(Icons.close_outlined),
      onPressed: () {
        setState(() {
          mc = "";
          _myAppBar = _customAppBar(
            _getDropdown(),
            _defaultAppBarAction(),
          );
        });
      },
    );
  }

  Widget _udateAppBarAction() {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        setState(() {
          _myAppBar = _customAppBar(
            _getDropdown(),
            _defaultAppBarAction(),
          );
        });
      },
    );
  }

  // Widget _actionUpdateDelete() {
  //   return Row(
  //     children: [
  //       GestureDetector(
  //         child: const Icon(
  //           Icons.delete_outline,
  //           color: LightColors.kWhite,
  //         ),
  //         onTap: () {
  //           setState(() {
  //             _deleteTask(_idToUpdateOrDelete);
  //           });
  //         },
  //       ),
  //       GestureDetector(
  //         child: const Icon(
  //           Icons.edit_outlined,
  //           color: LightColors.kWhite,
  //         ),
  //       ),
  //     ],
  // );
  //}

}

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'Nous évaluer',
  minDays: 0,
  minLaunches: 3,
  remindDays: 2,
  remindLaunches: 7,
  googlePlayIdentifier: 'com.alga.to_do_list',
);
