import 'package:flutter/material.dart';
import 'package:sadaqah_manager/screens/loan/screen_add_debt.dart';
import 'package:sadaqah_manager/screens/loan/screen_add_lend_insecure.dart';
import 'package:sadaqah_manager/screens/loan/screen_add_lend_secure.dart';
import 'package:sadaqah_manager/screens/loan/screen_display_loan_summary.dart';
import 'package:sadaqah_manager/model/model_loan.dart';

import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/util/scrollbar.dart';
import 'package:sadaqah_manager/util/country.dart';
import 'package:sadaqah_manager/util/utils/utils.dart';
import 'package:sadaqah_manager/util/country_pickers.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class Loan extends StatefulWidget {
  final appBarTitle;
  final page;
  int counter = 0;
  int userId;
  String currencyCode;
  Loan(this.appBarTitle, this.page, this.userId);

  @override
  State<StatefulWidget> createState() {
    return LoanState(this.appBarTitle, this.page, this.userId);
  }
}

class LoanState extends State<Loan> with SingleTickerProviderStateMixin {
  String appBarTitle;
  String page;
  int userId;
  LoanState(this.appBarTitle, this.page, this.userId);
  String currencyCode = '';
  String currencySymbol;
  Country _selectedDialogCountry;
  ModelSetting settings;

  DataHelper databaseHelper = DataHelper();

  List<ModelLoan> loanListB;
  List<ModelLoan> loanListLS;
  List<ModelLoan> loanListLIS;
  int count = 0;
  int countB = 0;
  int countLS = 0;
  int countLIS = 0;

  int flagB = 0;
  int flagLS = 0;
  int flagLIS = 0;

  final ScrollController controllerB = ScrollController();
  final ScrollController controllerLS = ScrollController();
  final ScrollController controllerLIS = ScrollController();
  double totalCashAmountB = 0;
  double totalCashAmountLS = 0;
  double totalCashAmountLIS = 0;

  bool _canShowButton = false;
  int buttonNavigation = 0;
  TabController tabController;
  var fabIcon;
  Color floatButtonColor = Colors.white;

  @override
  void initState() {
    updateListViewSetting(userId);
    super.initState();
    tabController = TabController(vsync: this, length: 4)
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
              updateListViewB();
              break;
            case 2:
              _canShowButton = true;
              buttonNavigation = 2;
              fabIcon = Icons.add;
              floatButtonColor = Colors.red;
              updateListViewLS();
              break;
            case 3:
              _canShowButton = true;
              buttonNavigation = 3;
              fabIcon = Icons.add;
              floatButtonColor = Colors.red;
              updateListViewLIS();
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
    if (loanListB == null) {
      loanListB = List<ModelLoan>();
      updateListViewB();
    }
    if (loanListLS == null) {
      loanListLS = List<ModelLoan>();
      updateListViewLS();
    }
    if (loanListLIS == null) {
      loanListLIS = List<ModelLoan>();
      updateListViewLIS();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
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
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text('SUMMARY',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0)),
                ),
                Tab(
                  child: Text('BORROWED',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0)),
                ),
                Tab(
                  child: Text('LENT (SECURE)',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11.5)),
                ),
                Tab(
                  child: Text('LENT (INSECURE)',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11.5)),
                ),
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
                  child: DisplayLoanSummary('Loan Summary', 'page', userId),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DraggableScrollbar(
                    child: getBorrowList(),
                    heightScrollThumb: 40.0,
                    controller: controllerB,
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DraggableScrollbar(
                    child: getLendSecureList(),
                    heightScrollThumb: 40.0,
                    controller: controllerLIS,
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DraggableScrollbar(
                    child: getLendInsecureList(),
                    heightScrollThumb: 40.0,
                    controller: controllerLS,
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
                          builder: (_) => AddBorrow(
                              ModelLoan('', 0, '', 'borrow', '', userId),
                              'Add New Debt',
                              'Save',
                              this.userId,
                              0,
                              currencyCode,
                              settings),
                        ),
                      )
                          .then((onValue) {
                        updateListViewB();
                        ;
                      });
                    } else if (buttonNavigation == 2) {
                      Navigator.of(context)
                          .push(
                        new MaterialPageRoute(
                          builder: (_) => AddLend(
                              ModelLoan('', 0.0, '', '', 'lendsecure', userId),
                              'Add Lend (secure)',
                              'Save',
                              this.userId,
                              0,
                              currencyCode),
                        ),
                      )
                          .then((onValue) {
                        updateListViewLS();
                      });
                    } else if (buttonNavigation == 3) {
                      Navigator.of(context)
                          .push(
                        new MaterialPageRoute(
                          builder: (_) => AddLendInsecure(
                              ModelLoan('', 0.0, '', '', 'lendsecure', userId),
                              'Add Lend (Insecure)',
                              'Delete',
                              this.userId,
                              0,
                              currencyCode),
                        ),
                      )
                          .then((onValue) {
                        updateListViewLIS();
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

  ListView getBorrowList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: controllerB,
        itemCount: countB,
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
                      child: Text(this.loanListB[position].description,
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text(
                        '${this.loanListB[position].amount.toStringAsFixed(2)}  ',
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
                  this.loanListB[position].date,
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
                    await _asyncConfirmDialogB(context, position);
                print("Confirm Action $action");
                if (flagB == 1) {
                  _delete(context, loanListB[position]);
                }
              },
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToB(this.loanListB[position], 'Edit Debt entry',
                    'Delete', this.userId, position);
              },
            ),
          );
        });
  }

  ListView getLendInsecureList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: controllerLIS,
        itemCount: countLIS,
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
                      child: Text(this.loanListLIS[position].description,
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text(
                        '${this.loanListLIS[position].amount.toStringAsFixed(2)}  ',
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
                  this.loanListLIS[position].date,
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
                    await _asyncConfirmDialogLIS(context, position);
                if (flagLIS == 1) {
                  _delete(context, loanListLIS[position]);
                }
              },
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateLIS(this.loanListLIS[position], 'Edit Lend (Insecure)',
                    'Delete', this.userId, position);
              },
            ),
          );
        });
  }

  ListView getLendSecureList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        controller: controllerLS,
        itemCount: countLS,
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
                      child: Text(this.loanListLS[position].description,
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text(
                        '${this.loanListLS[position].amount.toStringAsFixed(2)}  ',
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
                  this.loanListLS[position].date,
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
                    await _asyncConfirmDialogLS(context, position);
                print("Confirm Action $action");
                if (flagLS == 1) {
                  _delete(context, loanListLS[position]);
                }
              },
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateLS(this.loanListLS[position], 'Edit Lend (Secure)',
                    'Delete', this.userId, position);
              },
            ),
          );
        });
  }

  void updateListViewB() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelLoan>> cashListFuture =
          databaseHelper.getLoanList('loan', 'borrow', userId);
      cashListFuture.then((cashList) {
        if (this.mounted) {
          setState(() {
            this.loanListB = cashList;
            this.countB = cashList.length;
            this.totalCashAmountB = getCashInHandTotalB();
          });
        }
      });
    });
  }

  void updateListViewLS() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelLoan>> cashListFuture =
          databaseHelper.getLoanList('loan', 'lendsecure', userId);
      cashListFuture.then((cashList) {
        if (this.mounted) {
          setState(() {
            this.loanListLS = cashList;
            this.countLS = cashList.length;
            this.totalCashAmountLS = getCashInHandTotalLS();
          });
        }
      });
    });
  }

  void updateListViewLIS() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelLoan>> cashListFuture =
          databaseHelper.getLoanList('loan', 'lendinsecure', userId);
      cashListFuture.then((cashList) {
        if (this.mounted) {
          setState(() {
            this.loanListLIS = cashList;
            this.countLIS = cashList.length;
            this.totalCashAmountLIS = getCashInHandTotalLIS();
          });
        }
      });
    });
  }

  double getCashInHandTotalB() {
    double totalAmountCashInHand = 0.0;
    for (int i = 0; i <= loanListB.length - 1; i++) {
      totalAmountCashInHand = totalAmountCashInHand + this.loanListB[i].amount;
    }
    return totalAmountCashInHand;
  }

  double getCashInHandTotalLS() {
    double totalAmountCashInHand = 0.0;
    for (int i = 0; i <= loanListLS.length - 1; i++) {
      totalAmountCashInHand = totalAmountCashInHand + this.loanListLS[i].amount;
    }
    return totalAmountCashInHand;
  }

  double getCashInHandTotalLIS() {
    double totalAmountCashInHand = 0.0;
    for (int i = 0; i <= loanListLIS.length - 1; i++) {
      totalAmountCashInHand =
          totalAmountCashInHand + this.loanListLIS[i].amount;
    }
    return totalAmountCashInHand;
  }

  Future<ConfirmAction> _asyncConfirmDialogB(
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
                flagB = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flagB = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialogLIS(
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
                flagLIS = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flagLIS = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _asyncConfirmDialogLS(
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
                flagLS = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flagLS = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  void navigateToB(ModelLoan loan, String title, String button, int finaluserid,
      int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddBorrow(loan, title, button, finaluserid, position, currencyCode,
          this.settings);
    }));

    if (result == true) {
      updateListViewB();
    }
  }

  void _delete(BuildContext context, ModelLoan loan) async {
    int result = await databaseHelper.deleteLoan(loan.loanid);
    if (result != 0) {
      _showSnackBar(context, 'Borrow Deleted Successfully');
      updateListViewB();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateLIS(ModelLoan loan, String title, String button, int finaluserid,
      int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddLendInsecure(
          loan, title, button, finaluserid, position, currencyCode);
    }));

    if (result == true) {
      updateListViewLIS();
    }
  }

  void navigateLS(ModelLoan loan, String title, String button, int finaluserid,
      int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddLend(loan, title, button, finaluserid, position, currencyCode);
    }));

    if (result == true) {
      updateListViewLS();
    }
  }

  void updateListViewSetting(int userId) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<ModelSetting> settingListFuture =
          databaseHelper.getSettingList(userId);
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
