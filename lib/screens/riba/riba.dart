import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sadaqah_manager/screens/riba/screen_display_riba_summary.dart';
import 'package:sadaqah_manager/model/model_riba.dart';
import 'package:sadaqah_manager/screens/riba/screen_add_riba_received.dart';
import 'package:sadaqah_manager/screens/riba/screen_add_riba_paid.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sadaqah_manager/util/scrollbar.dart';
import 'dart:async';
import 'package:sadaqah_manager/util/country.dart';
import 'package:sadaqah_manager/util/utils/utils.dart';
import 'package:sadaqah_manager/util/country_pickers.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class Riba extends StatefulWidget {
  final appBarTitle;
  final page;
  final finaluserid;
  Riba(this.appBarTitle, this.page, this.finaluserid);

  @override
  State<StatefulWidget> createState() {
    return RibaState(this.appBarTitle, this.page, this.finaluserid);
  }
}

class RibaState extends State<Riba> with SingleTickerProviderStateMixin {
  String appBarTitle;
  String page;
  final finaluserid;
  RibaState(this.appBarTitle, this.page, this.finaluserid);
  int countR = 0;
  int countP = 0;
  int countS = 0;
  String currencyCode = '';
  String currencySymbol;
  Country _selectedDialogCountry;
  ModelSetting settings;
  DataHelper databaseHelper = DataHelper();

  bool _canShowButton = false;
  int buttonNavigation = 0;
  TabController tabController;
  var fabIcon;
  Color floatButtonColor = Colors.white;

  int flagR = 0;
  int flagP = 0;

  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();
  List<ModelRiba> ribaListReceived;
  List<ModelRiba> ribaListPaid;
  double totalRibaReceived = 0;
  double totalRibaPaid = 0;
  double ribaBalance = 0;

  @override
  void initState() {
    updateListViewSetting(finaluserid);
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          switch (tabController.index) {
            case 0:
              _canShowButton = false;
              buttonNavigation = 0;
              break;
            case 1:
              _canShowButton = true;
              buttonNavigation = 1;
              fabIcon = Icons.add;
              floatButtonColor = Colors.red;
              updateRibaReceived();
              break;
            case 2:
              _canShowButton = true;
              buttonNavigation = 2;
              fabIcon = Icons.add;
              floatButtonColor = Colors.red;
              updateRibaPaid();
              break;
          }
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  Widget build(BuildContext context) {
    if (ribaListReceived == null) {
      ribaListReceived = List<ModelRiba>();
      updateRibaReceived();
    }
    if (ribaListPaid == null) {
      ribaListPaid = List<ModelRiba>();
      updateRibaPaid();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: new Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text('SUMMARY  ',
                      style:
                          new TextStyle(color: Colors.white, fontSize: 14.0)),
                ),
                Tab(child: Text('RECEIVED')),
                Tab(child: Text('PAYMENTS                    ')),
              ],
              controller: tabController,
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DisplayRibaSummary(
                      'Display All Riba', 'page', finaluserid),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DraggableScrollbar(
                    child: getRibaReceivedList(),
                    heightScrollThumb: 40.0,
                    controller: controller1,
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DraggableScrollbar(
                    child: getRibaPaidList(),
                    heightScrollThumb: 40.0,
                    controller: controller2,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: _canShowButton
              ? FloatingActionButton(
                  onPressed: () {
                    if (buttonNavigation == 0) {
                    } else if (buttonNavigation == 1) {
                      Navigator.of(context)
                          .push(
                        new MaterialPageRoute(
                          builder: (_) => AddRibaRecived(
                              ModelRiba('', 0.0, '', '', finaluserid),
                              'Add Received Riba',
                              'Save',
                              this.finaluserid,
                              0,
                              this.currencyCode,
                              this.settings),
                        ),
                      )
                          .then((onValue) {
                        updateRibaReceived();
                      });
                    } else if (buttonNavigation == 2) {
                      Navigator.of(context)
                          .push(
                        new MaterialPageRoute(
                          builder: (_) => AddRibaPaid(
                              ModelRiba('', 0.0, '', '', finaluserid),
                              'Add Paid Riba ',
                              'Save',
                              this.finaluserid,
                              0,
                              currencyCode,
                              this.ribaBalance),
                        ),
                      )
                          .then((onValue) {
                        updateRibaPaid();
                      });
                    }
                  },
                  child: Icon(fabIcon),
                  backgroundColor: floatButtonColor,
                )
              : SizedBox(),
        ),
      ),
    );
  }

  ListView getRibaReceivedList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: controller1,
        itemCount: countR,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            elevation: 6,
            margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(this.ribaListReceived[position].bankName,
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text(
                        '${this.ribaListReceived[position].amount.toStringAsFixed(2)}',
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    new Text(' $currencySymbol',
                        softWrap: true,
                        style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        )),
                  ]),
              dense: true,
              subtitle: Row(children: <Widget>[
                Text(
                  this.ribaListReceived[position].date,
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 200.0),
                ),
              ]),
              onLongPress: () async {
                final ConfirmAction action =
                    await _asyncConfirmDialogR(context, position);
                if (flagR == 1) {
                  _deleteR(context, ribaListReceived[position]);
                }
              },
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToRR(this.ribaListReceived[position],
                    'Edit Riba Received', 'Delete', this.finaluserid, position);
              },
            ),
          );
        });
  }

  ListView getRibaPaidList() {
    return ListView.builder(
        controller: controller2,
        itemCount: countP,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            elevation: 6,
            margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(this.ribaListPaid[position].bankName,
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text(
                        '${this.ribaListPaid[position].amount.abs().toStringAsFixed(2)}',
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    new Text(' $currencySymbol',
                        softWrap: true,
                        style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        )),
                  ]),
              dense: true,
              subtitle: Row(children: <Widget>[
                Text(
                  this.ribaListPaid[position].date,
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 200.0),
                ),
              ]),
              onLongPress: () async {
                final ConfirmAction action =
                    await _asyncConfirmDialogP(context, position);
                print("Confirm Action $action");
                if (flagP == 1) {
                  _deleteP(context, ribaListPaid[position]);
                }
              },
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToRP(this.ribaListPaid[position], 'Edit Riba Paid',
                    'Delete', this.finaluserid, position);
              },
            ),
          );
        });
  }

  void navigateToRR(ModelRiba riba, String title, String button,
      int finaluserid, int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddRibaRecived(
          riba, title, button, finaluserid, position, currencyCode, settings);
    }));

    if (result == true) {
      updateRibaReceived();
    }
  }

  void navigateToRP(ModelRiba riba, String title, String button,
      int finaluserid, int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddRibaPaid(riba, title, button, finaluserid, position,
          currencyCode, this.ribaBalance);
    }));

    if (result == true) {
      updateRibaPaid();
    }
  }

  void _deleteR(BuildContext context, ModelRiba riba) async {
    int result = await databaseHelper.deleteRiba(riba.ribaId);
    if (result != 0) {
      _showSnackBar(context, 'Received Riba Deleted Successfully');
      updateRibaReceived();
    }
  }

  void _deleteP(BuildContext context, ModelRiba riba) async {
    int result = await databaseHelper.deleteRiba(riba.ribaId);
    if (result != 0) {
      _showSnackBar(context, 'Paid Riba Deleted Successfully');
      updateRibaPaid();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateRibaReceived() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelRiba>> ribaListFuture =
          databaseHelper.getRibaListReceived(finaluserid);
      ribaListFuture.then((ribaList) {
        if (this.mounted) {
          setState(() {
            this.ribaListReceived = ribaList;
            this.countR = ribaListReceived.length;
            this.totalRibaReceived = getRibaTotalReceived();
            this.ribaBalance = totalRibaReceived - totalRibaPaid;
          });
        }
      });
    });
  }

  double getRibaTotalReceived() {
    double totalAmountRiba = 0.0;
    for (int i = 0; i <= ribaListReceived.length - 1; i++) {
      totalAmountRiba = totalAmountRiba + this.ribaListReceived[i].amount;
    }
    return totalAmountRiba;
  }

  double getRibaTotalPaid() {
    double totalAmountRiba = 0.0;
    for (int i = 0; i <= ribaListPaid.length - 1; i++) {
      totalAmountRiba = totalAmountRiba + this.ribaListPaid[i].amount;
    }
    return totalAmountRiba.abs();
  }

  Future<ConfirmAction> _asyncConfirmDialogR(
      BuildContext context, int position) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation ?'),
          content: const Text('Are You Confirm to delete'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                flagR = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flagR = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialogP(
      BuildContext context, int position) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation ?'),
          content: const Text('Are You Confirm to delete'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                flagP = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flagP = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  void updateRibaPaid() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelRiba>> ribaListFuture =
          databaseHelper.getRibaListPaid(finaluserid);
      ribaListFuture.then((ribaList) {
        if (this.mounted) {
          setState(() {
            this.ribaListPaid = ribaList;
            this.countP = ribaListPaid.length;
            this.totalRibaPaid = getRibaTotalPaid();
            this.ribaBalance = totalRibaReceived - totalRibaPaid;
          });
        }
      });
    });
  }

  void updateListViewSetting(int finaluserid) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<ModelSetting> settingListFuture =
          databaseHelper.getSettingList(finaluserid);
      settingListFuture.then((settingList) {
        if (this.mounted) {
          setState(() {
            this.settings = settingList;
            _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode(
                '${settingList.country}');
            this.currencyCode = _selectedDialogCountry.currencyCode;
            this.currencySymbol = _selectedDialogCountry.currencySymbol;
          });
        }
      });
    });
  }
}
