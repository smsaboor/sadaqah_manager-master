import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:sadaqah_manager/screens/Assets/screen_display_summary_assets.dart';
import 'package:sadaqah_manager/model/model_cash.dart';
import 'package:sadaqah_manager/model/model_metal.dart';
import 'package:sadaqah_manager/screens/assets/screen_add_cashinbank.dart';
import 'package:sadaqah_manager/screens/assets/screen_add_cashinhand.dart';
import 'package:sadaqah_manager/screens/assets/screen_add_gold.dart';
import 'package:sadaqah_manager/screens/assets/screen_add_silver.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/util/country.dart';
import 'package:sadaqah_manager/util/utils/utils.dart';
import 'package:sadaqah_manager/util/country_pickers.dart';
import 'package:sadaqah_manager/util/scrollbar.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class Assets extends StatefulWidget {
  final appBarTitle;
  final page;
  final finaluserid;
  final ModelSetting settings;
  String currencyCode;

  Assets(this.appBarTitle, this.page, this.finaluserid, this.settings);

  @override
  State<StatefulWidget> createState() {
    return AssetsState(
        this.appBarTitle, this.page, this.finaluserid, this.settings);
  }
}

class AssetsState extends State<Assets> with SingleTickerProviderStateMixin {
  String appBarTitle;
  String page;
  final finaluserid;
  final ModelSetting settings;

  AssetsState(this.appBarTitle, this.page, this.finaluserid, this.settings);
  double goldRate18C = 0;
  double goldRate22C = 0;
  double goldRate24C = 0;
  double goldRate20C = 0;

  double silverRate18C = 0;
  double silverRate20C = 0;
  double silverRate22C = 0;
  double silverRate24C = 0;
  String currencyCode = '';
  String currencySymbol;
  Country _selectedDialogCountry;

  DataHelper databaseHelper = DataHelper();
  bool _canShowButton = false;
  int buttonNavigation = 0;
  TabController tabController;
  var fabIcon;
  Color floatButtonColor = Colors.white;

  int deletePosition = 0;
  double amountDS = 0.0;
  double amountDG = 0.0;
  double totalCIHAmount = 0;
  double totalCIBAmount = 0;
  double goldRate = 0;
  double silverRate = 0;

  List<ModelCash> cashListCIH;
  List<ModelCash> cashListCIB;
  List<ModelMetal> metalListG;
  List<ModelMetal> metalListS;
  int countCIH = 0;
  int countCIB = 0;
  int countG = 0;
  int countS = 0;

  int flagCIH = 0;
  int flagCIB = 0;
  int flagG = 0;
  int flagS = 0;

  final ScrollController controllerCIH = ScrollController();
  final ScrollController controllerCIB = ScrollController();
  final ScrollController controllerG = ScrollController();
  final ScrollController controllerS = ScrollController();

  @override
  void initState() {
    updateListViewSetting();
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 5)
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
              updateListViewCIH();
              break;
            case 2:
              _canShowButton = true;
              buttonNavigation = 2;
              fabIcon = Icons.add;
              floatButtonColor = Colors.red;
              updateListViewCIB();
              break;
            case 3:
              _canShowButton = true;
              buttonNavigation = 3;
              fabIcon = Icons.add;
              floatButtonColor = Colors.red;
              updateListViewG();
              break;
            case 4:
              _canShowButton = true;
              buttonNavigation = 4;
              fabIcon = Icons.add;
              floatButtonColor = Colors.red;
              updateListViewS();
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
    if (cashListCIH == null) {
      cashListCIH = List<ModelCash>();
      updateListViewCIH();
    }
    if (cashListCIB == null) {
      cashListCIB = List<ModelCash>();
      updateListViewCIB();
    }
    if (metalListG == null) {
      metalListG = List<ModelMetal>();
      updateListViewG();
    }
    if (metalListS == null) {
      metalListS = List<ModelMetal>();
      updateListViewS();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 5,
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
                  child: Text('SUMMARY',
                      style:
                          new TextStyle(color: Colors.white, fontSize: 14.0)),
                ),
                Tab(child: Center(child: Text('CASH'))),
                Tab(child: Center(child: Text('BANK'))),
                Tab(text: 'GOLD'),
                Tab(text: 'SILVER'),
              ],
              controller: tabController,
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              Container(
                child: DisplayAllAssets(
                    'Display All Assets', 'page', finaluserid, settings),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DraggableScrollbar(
                    child: getCashInHandList(),
                    heightScrollThumb: 40.0,
                    controller: controllerCIH,
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DraggableScrollbar(
                    child: getCashInBankList(),
                    heightScrollThumb: 40.0,
                    controller: controllerCIB,
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DraggableScrollbar(
                    child: getGoldListView(),
                    heightScrollThumb: 40.0,
                    controller: controllerG,
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DraggableScrollbar(
                    child: getSilverListView(),
                    heightScrollThumb: 40.0,
                    controller: controllerS,
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
                          .push(new MaterialPageRoute(
                              builder: (_) => AddCashInHand(
                                  ModelCash('', 0.0, '', '', 'cashinhand',
                                      finaluserid),
                                  'Add Cash',
                                  'Save',
                                  this.finaluserid,
                                  0,
                                  currencyCode,
                                  settings)))
                          .then((onValue) {
                        updateListViewCIH();
                      });
                    } else if (buttonNavigation == 2) {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(
                              builder: (_) => AddCashInBank(
                                  ModelCash(
                                      '', 0, '', '', 'cashinbank', finaluserid),
                                  "Add Cash of Bank ",
                                  'Save',
                                  finaluserid,
                                  0,
                                  currencyCode,
                                  settings)))
                          .then((onValue) {
                        updateListViewCIB();
                      });
                    } else if (buttonNavigation == 3) {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(
                              builder: (_) => AddGold(
                                  ModelMetal('', 0.0, 0, '', '', 'gold',
                                      this.finaluserid),
                                  'Add Gold Item',
                                  'Save',
                                  0,
                                  this.finaluserid,
                                  0)))
                          .then((onValue) {
                        updateListViewG();
                      });
                    } else if (buttonNavigation == 4) {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(
                              builder: (_) => AddSilver(
                                  ModelMetal('', 0.0, 0.0, '', '', 'silver',
                                      this.finaluserid),
                                  'Add Silver Item',
                                  'Save',
                                  this.finaluserid,
                                  0)))
                          .then((onValue) {
                        updateListViewS();
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

  ListView getCashInHandList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: controllerCIH,
        itemCount: countCIH,
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
                      child: Text(this.cashListCIH[position].title,
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text(
                        '${this.cashListCIH[position].amount.toStringAsFixed(2)}  ',
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    new Text('$currencySymbol',
                        softWrap: true,
                        style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                  ]),
              dense: true,
              subtitle: Row(children: <Widget>[
                Text(
                  this.cashListCIH[position].date,
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                ),
                new Text(
                  ' ',
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                new Text(
                  ' ',
                  softWrap: true,
                ),
              ]),
              onLongPress: () async {
                final ConfirmAction action =
                    await _asyncConfirmDialogCIH(context, position);
                print("Confirm Action $action");
                if (flagCIH == 1) {
                  _deleteCIH(context, cashListCIH[position]);
                }
              },
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToCIH(this.cashListCIH[position], 'Edit Cash', 'Delete',
                    this.finaluserid, position);
              },
            ),
          );
        });
  }

  ListView getCashInBankList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: controllerCIB,
        itemCount: countCIB,
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
                      child: Text(this.cashListCIB[position].title,
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text(
                        '${this.cashListCIB[position].amount.toStringAsFixed(2)}  ',
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    new Text('$currencySymbol',
                        softWrap: true,
                        style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                  ]),
              dense: true,
              subtitle: Row(children: <Widget>[
                Text(
                  this.cashListCIB[position].date,
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                ),
                new Text(
                  ' ',
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                new Text(
                  ' ',
                  softWrap: true,
                ),
              ]),
              onLongPress: () async {
                final ConfirmAction action =
                    await _asyncConfirmDialogCIB(context, position);
                print("Confirm Action $action");
                if (flagCIB == 1) {
                  _deleteCIB(context, cashListCIB[position]);
                }
              },
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToCIB(this.cashListCIB[position], 'Edit Bank Cash',
                    'Delete', this.finaluserid, position);
              },
            ),
          );
        });
  }

  ListView getGoldListView() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: controllerG,
        itemCount: countG,
        itemBuilder: (BuildContext context, int position) {
          if (this.metalListG[position].carat == 18) {
            goldRate = goldRate18C;
          } else if (this.metalListG[position].carat == 20) {
            goldRate = goldRate20C;
          } else if (this.metalListG[position].carat == 22) {
            goldRate = goldRate22C;
          } else if (this.metalListG[position].carat == 24) {
            goldRate = goldRate24C;
          }
          amountDG = this.metalListG[position].weight * goldRate;
          return Card(
            elevation: 6,
            margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(this.metalListG[position].item,
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 17)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text('${this.amountDG.toStringAsFixed(2)} ',
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    new Text('$currencySymbol',
                        style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                  ]),
              dense: true,
              subtitle: Row(children: <Widget>[
                Text(
                  this.metalListG[position].date,
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(right: 220.0),
                ),
                new Text(
                  '${this.metalListG[position].weight.toString()} gm',
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                ),
              ]),
              onLongPress: () async {
                final ConfirmAction action =
                    await _asyncConfirmDialogG(context, position);
                print("Confirm Action $action");
                if (flagG == 1) {
                  _deleteG(context, metalListG[position]);
                }
              },
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToDetailG(this.metalListG[position], 'Edit Gold Item',
                    'Delete', this.finaluserid, position);
              },
            ),
          );
        });
  }

  ListView getSilverListView() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: controllerS,
        itemCount: countS,
        itemBuilder: (BuildContext context, int position) {
          if (this.metalListS[position].carat == 18) {
            silverRate = silverRate18C;
          } else if (this.metalListS[position].carat == 20) {
            silverRate = silverRate20C;
          } else if (this.metalListS[position].carat == 22) {
            silverRate = silverRate22C;
          } else if (this.metalListS[position].carat == 24) {
            silverRate = silverRate24C;
          }
          amountDS = this.metalListS[position].weight * silverRate;
          return Card(
            elevation: 6,
            margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(this.metalListS[position].item,
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 17)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text('${amountDS.toStringAsFixed(2)} ',
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    new Text('$currencySymbol',
                        style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                  ]),
              dense: true,
              subtitle: Row(children: <Widget>[
                Text(
                  this.metalListS[position].date,
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(right: 220.0),
                ),
                new Text(
                  '${this.metalListS[position].weight.toString()} gm',
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                ),
              ]),
              onLongPress: () async {
                final ConfirmAction action =
                    await _asyncConfirmDialogS(context, position);
                print("Confirm Action $action");
                if (flagS == 1) {
                  _deleteS(context, metalListS[position]);
                }
              },
              onTap: () {
                navigateToDetailS(this.metalListS[position], 'Edit Silver Item',
                    'Delete', this.finaluserid, position);
              },
            ),
          );
        });
  }

  void navigateToDetailG(ModelMetal metal, String title, String button,
      int finaluserid, int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddGold(
          metal, title, button, deletePosition, finaluserid, position);
    }));

    if (result == true) {
      updateListViewG();
    }
  }

  void navigateToDetailS(ModelMetal metal, String title, String button,
      int finaluserid, int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddSilver(metal, title, button, finaluserid, position);
    }));

    if (result == true) {
      updateListViewS();
    }
  }

  void navigateToCIB(ModelCash cash, String title, String button,
      int finaluserid, int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddCashInBank(
          cash, title, button, finaluserid, position, currencyCode, settings);
    }));

    if (result == true) {
      updateListViewCIB();
    }
  }

  void navigateToCIH(ModelCash cash, String title, String button,
      int finaluserid, int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddCashInHand(
          cash, title, button, finaluserid, position, currencyCode, settings);
    }));

    if (result == true) {
      updateListViewCIH();
    }
  }

  void updateListViewG() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelMetal>> metalListFuture =
          databaseHelper.getMetalList(finaluserid, 'metal', 'gold');
      metalListFuture.then((metalList) {
        if (this.mounted) {
          setState(() {
            this.metalListG = metalList;
            this.countG = metalList.length;
          });
        }
      });
    });
  }

  void updateListViewS() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelMetal>> metalListFuture =
          databaseHelper.getMetalList(finaluserid, 'metal', 'silver');
      metalListFuture.then((metalList) {
        if (this.mounted) {
          setState(() {
            this.metalListS = metalList;
            this.countS = metalList.length;
          });
        }
      });
    });
  }

  void updateListViewCIB() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelCash>> cashListFuture = databaseHelper.getCashList(
          this.finaluserid,
          'cash',
          'cashinbank',
          settings.startDate,
          settings.endDate);
      cashListFuture.then((cashList) {
        if (this.mounted) {
          setState(() {
            this.cashListCIB = cashList;
            this.countCIB = cashList.length;
            this.totalCIBAmount = getCashInBankTotal();
          });
        }
      });
    });
  }

  double getCashInBankTotal() {
    double totalAmountCashInBank = 0;
    for (int i = 0; i <= cashListCIB.length - 1; i++) {
      totalAmountCashInBank =
          totalAmountCashInBank + this.cashListCIB[i].amount;
    }
    return totalAmountCashInBank;
  }

  void updateListViewCIH() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelCash>> cashListFuture = databaseHelper.getCashList(
          finaluserid,
          'cash',
          'cashinhand',
          settings.startDate,
          settings.endDate);
      cashListFuture.then((cashList) {
        if (this.mounted) {
          setState(() {
            this.cashListCIH = cashList;
            this.countCIH = cashList.length;
            this.totalCIHAmount = getCashInHandTotal();
          });
        }
      });
    });
  }

  double getCashInHandTotal() {
    double totalAmountCashInHand = 0.0;
    for (int i = 0; i <= cashListCIH.length - 1; i++) {
      totalAmountCashInHand =
          totalAmountCashInHand + this.cashListCIH[i].amount;
    }
    return totalAmountCashInHand;
  }

  void _deleteCIH(BuildContext context, ModelCash cash) async {
    int result = await databaseHelper.deleteCash(cash.cashId);
    if (result != 0) {
      _showSnackBar(context, 'Cash-in-Hand Deleted Successfully');
      updateListViewCIH();
    }
  }

  void _deleteCIB(BuildContext context, ModelCash cash) async {
    int result = await databaseHelper.deleteCash(cash.cashId);
    if (result != 0) {
      _showSnackBar(context, 'Cash-in-Bank Deleted Successfully');
      updateListViewCIB();
    }
  }

  void _deleteG(BuildContext context, ModelMetal metal) async {
    int result = await databaseHelper.deleteMetal(metal.metalId);
    if (result != 0) {
      _showSnackBar(context, 'Gold Item Deleted Successfully');
      updateListViewG();
    }
  }

  void _deleteS(BuildContext context, ModelMetal metal) async {
    int result = await databaseHelper.deleteMetal(metal.metalId);
    if (result != 0) {
      _showSnackBar(context, 'Silver Item Deleted Successfully');
      updateListViewS();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<ConfirmAction> _asyncConfirmDialogCIH(
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
                flagCIH = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flagCIH = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialogCIB(
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
                flagCIB = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flagCIB = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialogG(
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
                flagG = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flagG = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialogS(
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
                flagS = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flagS = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  void updateListViewSetting() {
    _selectedDialogCountry =
        CountryPickerUtils.getCountryByIsoCode('${settings.country}');

    goldRate18C = settings.goldRate18C;
    goldRate20C = settings.goldRate20C;
    goldRate22C = settings.goldRate22C;
    goldRate24C = settings.goldRate24C;

    silverRate18C = settings.silverRate18C;
    silverRate20C = settings.silverRate20C;
    silverRate22C = settings.silverRate22C;
    silverRate24C = settings.silverRate24C;
    currencyCode = _selectedDialogCountry.currencyCode;
    currencySymbol = _selectedDialogCountry.currencySymbol;
  }
}
