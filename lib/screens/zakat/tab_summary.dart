import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sadaqah_manager/model/model_metal.dart';
import 'package:sadaqah_manager/model/model_cash.dart';
import 'package:sadaqah_manager/model/model_riba.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/model/model_zakat_paid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:sadaqah_manager/model/model_loan.dart';
import 'package:sadaqah_manager/util/utils/utils.dart';
import 'package:sadaqah_manager/screens/zakat/screen_pay_zakat.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class DisplayZakatSummary extends StatefulWidget {
  final appBarTitle;
  final page;
  int userId;
  ModelZakatPaid zakatPaid;
  ModelSetting settings;
  var funcZakatBalance;

  DisplayZakatSummary(this.zakatPaid, this.appBarTitle, this.page, this.userId,
      this.settings, this.funcZakatBalance);

  @override
  State<StatefulWidget> createState() {
    return DisplayZakatSummaryState(this.zakatPaid, this.appBarTitle, this.page,
        this.userId, this.settings, this.funcZakatBalance);
  }
}

class DisplayZakatSummaryState extends State<DisplayZakatSummary> {
  String appBarTitle;
  String page;
  var cash;
  int userId;
  int flag = 0;
  final path = getDatabasesPath();
  String startDate = '', endDate = '';
  double nisab = 0.0;
  ModelZakatPaid zakatPaid;
  int differenceDate = 0;
  String currencyCode;
  String currencySymbol;
  var setZakatBalance;

  DisplayZakatSummaryState(this.zakatPaid, this.appBarTitle, this.page,
      this.userId, this.settings, this.setZakatBalance);
  DataHelper databaseHelper = DataHelper();

  List<ModelCash> cashList;
  List<ModelMetal> metalList;
  List<ModelLoan> loanList;
  List<ModelRiba> ribaList;
  ModelSetting settings;
  List<ModelZakatPaid> zakatPaidList;
  double totalCashInHand = 0;
  double totalCashInBank = 0;
  double totalGold = 0;
  double totalSilver = 0;
  double totalAllAssets = 0;
  double totalBorrow = 0;
  double totalLendSecure = 0;
  double totalLendInSecure = 0;
  double totalAllLoan = 0;
  double totalPayableRiba = 0;
  double totalZakatPayable = 0;
  double totalZakatPaid = 0;
  double totalZakatBalance = 0;

  @override
  void initState() {
    debugPrint('summary');

    updateListViewSetting();
    super.initState();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (zakatPaidList == null) {
      cashList = List<ModelCash>();
      metalList = List<ModelMetal>();
      loanList = List<ModelLoan>();
      ribaList = List<ModelRiba>();
      zakatPaidList = List<ModelZakatPaid>();
      updateAll();
    }

    return Scaffold(
      body: getListView(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          if (this.totalZakatBalance <= 0) {
//            _showAlertDialog(
//                'Pay Zakat', 'There is no zakat due on your wealth');
//          } else {
//            Navigator.of(context)
//                .push(new MaterialPageRoute(
//                    builder: (_) => AddZakatPayment(
//                          ModelZakatPaid('', '', '', '', 0, '', this.userId),
//                          'Pay Zakat',
//                          'Save',
//                          this.userId,
//                          0,
//                          this.settings,
//                          this.totalZakatBalance,
//                        )))
//                .then((val) => {updateListZakatPaid(userId)});
//          }
//        },
//        child: Text('Pay'),
//        backgroundColor: Colors.red,
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  updateAll() {
    updateListZakatPaid(userId);
    updateListViewCash(
        'cash', 'cashinhand', this.startDate, this.endDate, this.userId);
    updateListViewCash(
        'cash', 'cashinbank', this.startDate, this.endDate, this.userId);
    updateListViewMetal(
        'metal', 'gold', '1900-01-01', this.startDate, this.userId);
    updateListViewMetal(
        'metal', 'silver', '1900-01-01', this.startDate, this.userId);
    updateListRiba(userId, this.startDate, this.endDate);
    updateListViewLoanDebt(
        'loan', 'borrow', this.startDate, this.endDate, this.userId);
    updateListViewLendSecure(
        'loan', 'lendsecure', this.startDate, this.endDate, this.userId);

    totalAllAssets = getAllTotal();
    calculateTotalZakat();
  }

  ListView getListView() {
    return ListView(
      children: <Widget>[
        totalZakatBalance < 0
            ? Card(
                color: Colors.white,
                borderOnForeground: true,
                child: ListTile(
                  title: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Icon(
                        Icons.warning,
                        size: 32.0,
                        color: Colors.red[600],
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                      ),
                      Expanded(
                        child: Text(
                            'There is inconsistency in your data entries. Please review all sections to get accurate results',
                            style: new TextStyle(
                                color: Colors.red[600], fontSize: 14.0)),
                      ),
                    ]),
                  ]),
                ),
              )
            : SizedBox(),
        Card(
          color: Colors.white,
          borderOnForeground: true,
          child: ListTile(
            title: Column(children: <Widget>[
              Row(children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                Expanded(
                  child: Text('Current Payable Period:',
                      style:
                          new TextStyle(color: Colors.green, fontSize: 14.0)),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                Text(startDate,
                    style: new TextStyle(color: Colors.black, fontSize: 14.0)),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                Text('To',
                    style: new TextStyle(color: Colors.black, fontSize: 14.0)),
                new Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                Text(endDate,
                    style: new TextStyle(color: Colors.black, fontSize: 14.0)),
              ]),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Icon(
                Icons.account_balance_wallet,
                size: 32.0,
                color: Colors.grey,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: Text('Total Cash',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalCashInHand.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Icon(
                Icons.account_balance,
                size: 32.0,
                color: Colors.grey,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: Text('Total Bank Balance',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalCashInBank.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Icon(
                Icons.business,
                size: 32.0,
                color: Colors.grey,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: Text('Total Gold Balance',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalGold.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Icon(
                Icons.business,
                size: 32.0,
                color: Colors.grey,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: Text('Total Silver balance',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalSilver.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Icon(
                Icons.business,
                size: 32.0,
                color: Colors.grey,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: Text('Total Lend\n(SECURE) balance',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalLendSecure.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Icon(
                Icons.business,
                size: 32.0,
                color: Colors.grey,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: Text('Total Debt',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text('-' + totalBorrow.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Icon(
                Icons.business,
                size: 32.0,
                color: Colors.grey,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: Text('Total Riba Balance',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text('-' + totalPayableRiba.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 50.0),
              ),
              Expanded(
                child: Text('Total Asset Value',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalAllAssets.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.yellow[100],
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 50.0),
              ),
              Expanded(
                child: Text('Nisab',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(settings.nisab.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 50.0),
              ),
              Expanded(
                child: Text('Total Zakat Payable (@ 2.5%)',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalZakatPayable.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 50.0),
              ),
              Expanded(
                child: Text('Total Payments',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalZakatPaid.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.greenAccent,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 50.0),
              ),
              Expanded(
                child: Text('Remaining Balance',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalZakatBalance.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${this.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
      ],
    );
  }

  // functions for Cash.................................................
  void updateListViewCash(String table, String type, String startdate,
      String enddate, int finaluserid) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelCash>> cashListFuture = databaseHelper.getCashListZakat(
          table, type, startdate, enddate, finaluserid);
      cashListFuture.then((cashList) {
        setState(() {
          this.cashList = cashList;
          if (type == 'cashinhand') {
            totalCashInHand = getCashTotal();
            totalAllAssets = getAllTotal();
          } else {
            totalCashInBank = getCashTotal();
            totalAllAssets = getAllTotal();
          }
          calculateTotalZakat();
        });
      });
    });
  }

  double getCashTotal() {
    double totalCash = 0.0;
    for (int i = 0; i <= cashList.length - 1; i++) {
      totalCash = totalCash + this.cashList[i].amount;
    }
    return totalCash;
  }

  // functions for Calculating Assets.................................................
  void updateListViewMetal(String table, String type, String startdate,
      String enddate, int finaluserid) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelMetal>> cashListFuture = databaseHelper
          .getMetalListZakat(table, type, startdate, enddate, finaluserid);
      cashListFuture.then((metalList) {
        setState(() {
          this.metalList = metalList;
          if (type == 'gold') {
            totalGold = getMetalTotalAmount(type);
            totalAllAssets = getAllTotal();
          } else {
            totalSilver = getMetalTotalAmount(type);
            totalAllAssets = getAllTotal();
          }
          calculateTotalZakat();
        });
      });
    });
  }

  double getMetalTotalAmount(String metal) {
    double totalWeight18CG = 0.0;
    double totalWeight20CG = 0.0;
    double totalWeight22CG = 0.0;
    double totalWeight24CG = 0.0;
    double totalWeight18CS = 0.0;
    double totalWeight20CS = 0.0;
    double totalWeight22CS = 0.0;
    double totalWeight24CS = 0.0;
    double totalAmount18CG = 0.0;
    double totalAmount20CG = 0.0;
    double totalAmount22CG = 0.0;
    double totalAmount24CG = 0.0;
    double gTotalAmountGold = 0.0;
    double totalAmount18CS = 0.0;
    double totalAmount20CS = 0.0;
    double totalAmount22CS = 0.0;
    double totalAmount24CS = 0.0;
    double gTotalAmountSilver = 0.0;
    double totalAmount = 0.0;
    if (metal == 'gold') {
      for (int i = 0; i <= metalList.length - 1; i++) {
        if (metalList[i].type == 'gold') {
          if (metalList[i].carat == 18) {
            totalWeight18CG = totalWeight18CG + this.metalList[i].weight;
          } else if (metalList[i].carat == 20) {
            totalWeight20CG = totalWeight20CG + this.metalList[i].weight;
          } else if (metalList[i].carat == 22) {
            totalWeight22CG = totalWeight22CG + this.metalList[i].weight;
          } else if (metalList[i].carat == 24) {
            totalWeight24CG = totalWeight24CG + this.metalList[i].weight;
          }
        }
      }
      totalAmount18CG = totalWeight18CG * this.settings.goldRate18C;
      totalAmount20CG = totalWeight20CG * this.settings.goldRate20C;
      totalAmount22CG = totalWeight22CG * this.settings.goldRate22C;
      totalAmount24CG = totalWeight24CG * this.settings.goldRate24C;
      gTotalAmountGold =
          totalAmount18CG + totalAmount20CG + totalAmount22CG + totalAmount24CG;
      totalAmount = gTotalAmountGold;
    } else {
      for (int i = 0; i <= metalList.length - 1; i++) {
        if (metalList[i].type == 'silver') {
          if (metalList[i].carat == 18) {
            totalWeight18CS = totalWeight18CS + this.metalList[i].weight;
          } else if (metalList[i].carat == 20) {
            totalWeight20CS = totalWeight20CS + this.metalList[i].weight;
          } else if (metalList[i].carat == 22) {
            totalWeight22CS = totalWeight22CS + this.metalList[i].weight;
          } else if (metalList[i].carat == 24) {
            totalWeight24CS = totalWeight24CS + this.metalList[i].weight;
          }
        }
      }
      totalAmount18CS = totalWeight18CS * this.settings.silverRate18C;
      totalAmount20CS = totalWeight20CS * this.settings.silverRate20C;
      totalAmount22CS = totalWeight22CS * this.settings.silverRate22C;
      totalAmount24CS = totalWeight24CS * this.settings.silverRate24C;
      gTotalAmountSilver =
          totalAmount18CS + totalAmount20CS + totalAmount22CS + totalAmount24CS;
      totalAmount = gTotalAmountSilver;
    }
    return totalAmount;
  }

  double getAllTotal() {
    double allTotal = 0;
    allTotal = this.totalCashInHand +
        this.totalCashInBank +
        this.totalGold +
        this.totalSilver +
        this.totalLendSecure -
        this.totalPayableRiba -
        this.totalBorrow;
    return allTotal;
  }

  void updateListViewSetting() {
    this.startDate = settings.startDate;
    this.endDate = settings.endDate;
    this.nisab = settings.nisab;
    this.currencyCode =
        CountryPickerUtils.getCountryByIsoCode('${settings.country}')
            .currencyCode;
    this.currencySymbol =
        CountryPickerUtils.getCountryByIsoCode('${settings.country}')
            .currencySymbol;
  }

  void updateListRiba(int userId, String startDate, String endDate) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelRiba>> ribaListFuture =
          databaseHelper.getRibaList(userId, startDate, endDate);
      ribaListFuture.then((ribaList) {
        setState(() {
          this.ribaList = ribaList;
          totalPayableRiba = getRibaTotal();
          totalAllAssets = getAllTotal();
          calculateTotalZakat();
        });
      });
    });
  }

  void updateListZakatPaid(int userId) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelZakatPaid>> zakatPaidListFuture =
          databaseHelper.getZakatPaidList(userId);
      zakatPaidListFuture.then((zakatPaidList) {
        if (this.mounted) {
          setState(() {
            this.zakatPaidList = zakatPaidList;
            totalZakatPaid = getZakatPaid();
            calculateTotalZakat();
          });
        }
      });
    });
  }

  double getRibaTotal() {
    double totalAmountRiba = 0;
    for (int i = 0; i <= ribaList.length - 1; i++) {
      totalAmountRiba = totalAmountRiba + this.ribaList[i].amount;
    }
    return totalAmountRiba;
  }

  double getLoanDebtTotal() {
    double totalAmountborrow = 0;
    for (int i = 0; i <= loanList.length - 1; i++) {
      if (loanList[i].type == 'borrow') {
        totalAmountborrow = totalAmountborrow + loanList[i].amount;
      }
    }
    return totalAmountborrow;
  }

  double getLendSecureTotal() {
    double totalLendS = 0;
    for (int i = 0; i <= loanList.length - 1; i++) {
      if (loanList[i].type == 'lendsecure') {
        totalLendS = totalLendS + loanList[i].amount;
      }
    }
    return totalLendS;
  }

  double getZakatPaid() {
    double zakatPaid = 0;
    for (int i = 0; i <= zakatPaidList.length - 1; i++) {
      zakatPaid = zakatPaid + this.zakatPaidList[i].amount;
    }
    return zakatPaid;
  }

  void updateListViewLendSecure(String table, String type, String startdate,
      String enddate, int finaluserid) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelLoan>> loanListFuture = databaseHelper.getLoanListZakat(
          table, type, startdate, enddate, userId);
      loanListFuture.then((loanList) {
        setState(() {
          this.loanList = loanList;
          totalLendSecure = getLendSecureTotal();
          totalAllAssets = getAllTotal();
          calculateTotalZakat();
        });
      });
    });
  }

  void updateListViewLoanDebt(String table, String type, String startdate,
      String enddate, int finaluserid) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelLoan>> loanListFuture = databaseHelper.getLoanListZakat(
          table, type, startdate, enddate, userId);
      loanListFuture.then((loanList) {
        setState(() {
          this.loanList = loanList;
          totalBorrow = getLoanDebtTotal();
          totalAllAssets = getAllTotal();
          calculateTotalZakat();
        });
      });
    });
  }

  calculateTotalZakat() {
    if (totalAllAssets >= this.nisab) {
      double totalCalculatedZakat = totalAllAssets / 40;
      this.totalZakatPayable = totalCalculatedZakat;
      this.totalZakatBalance = this.totalZakatPayable - this.totalZakatPaid;
    } else {
      this.totalZakatPayable = 0;
      this.totalZakatBalance = this.totalZakatPayable - this.totalZakatPaid;
    }
    setZakatBalance(totalZakatBalance);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
