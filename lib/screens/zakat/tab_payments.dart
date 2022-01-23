import 'package:flutter/material.dart';
import 'package:sadaqah_manager/model/model_zakat_paid.dart';
import 'package:sadaqah_manager/util/scrollbar.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/screens/zakat/screen_pay_zakat.dart';
import 'package:sadaqah_manager/util/utils/utils.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class DisplayZakatPaid extends StatefulWidget {
  final appBarTitle;
  final page;
  final userId;
  ModelSetting settings;
  var getZakatBalance;
  DisplayZakatPaid(this.appBarTitle, this.page, this.userId, this.settings,
      this.getZakatBalance);
  @override
  State<StatefulWidget> createState() {
    return DisplayZakatPaidState(this.appBarTitle, this.page, this.userId,
        this.settings, this.getZakatBalance);
  }
}

class DisplayZakatPaidState extends State<DisplayZakatPaid> {
  String appBarTitle;
  String page;
  final userId;
  var getZakatBalance;
  DisplayZakatPaidState(this.appBarTitle, this.page, this.userId, this.settings,
      this.getZakatBalance);
  int flag = 0;
  final ScrollController controller = ScrollController();

  DataHelper databaseHelper = DataHelper();
  List<ModelZakatPaid> zakatList;
  int count = 0;
  double totalRibaAmount;
  String currencyCode;
  String currencySymbol;
  ModelSetting settings;

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    this.currencyCode =
        CountryPickerUtils.getCountryByIsoCode('${settings.country}')
            .currencyCode;
    this.currencySymbol =
        CountryPickerUtils.getCountryByIsoCode('${settings.country}')
            .currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    if (zakatList == null) {
      zakatList = List<ModelZakatPaid>();
      updateListView();
    }

    return Scaffold(
      body: DraggableScrollbar(
        child: getUserListView(),
        heightScrollThumb: 40.0,
        controller: controller,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (this.getZakatBalance() <= 0) {
            _showAlertDialog(
                'Pay Zakat', 'There is no zakat due on your wealth');
          } else {
            Navigator.of(context)
                .push(new MaterialPageRoute(
                    builder: (_) => AddZakatPayment(
                          ModelZakatPaid('', '', '', '', 0, '', this.userId),
                          'Pay Zakat',
                          'Save',
                          this.userId,
                          0,
                          this.settings,
                          this.getZakatBalance(),
                        )))
                .then((val) => {updateListView()});
          }
        },
        child: Text('Pay'),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ListView getUserListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.bodyText1;

    return ListView.builder(
        controller: controller,
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          int countIndex = position + 1;
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
                      child: Text("${this.zakatList[position].title}",
                          style: new TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 17)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                    ),
                    new Text(
                        '${this.zakatList[position].amount.toStringAsFixed(2)}',
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                    ),
                    new Text(' ${this.currencySymbol}',
                        style: new TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        )),
                  ]),
              dense: true,
              subtitle: Row(children: <Widget>[
                Text(
                  this.zakatList[position].paymentDate,
                  softWrap: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 184.0),
                ),
              ]),
              onLongPress: () async {
                final ConfirmAction action =
                    await _asyncConfirmDialog(context, position);
                print("Confirm Action $action");
                if (flag == 1) {
                  _delete(context, zakatList[position]);
                }
              },
              onTap: () {
                navigateToDetail(this.zakatList[position], 'Edit Zakat Payment',
                    'Delete', this.userId, position);
              },
            ),
          );
        });
  }

  void navigateToDetail(ModelZakatPaid zakat, String title, String button,
      int finaluserid, int position) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddZakatPayment(
        zakat,
        title,
        button,
        finaluserid,
        position,
        settings,
        this.getZakatBalance(),
      );
    }));

    if (result == true) {
      updateListView();
    }
  }

  void _delete(BuildContext context, ModelZakatPaid zakat) async {
    int result = await databaseHelper.deleteZakatPaid(zakat.zakatPaymentId);
    if (result != 0) {
      _showSnackBar(context, 'Payment deleted successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelZakatPaid>> zakatPaidListFuture =
          databaseHelper.getZakatPaidList(this.userId);
      zakatPaidListFuture.then((zakatList) {
        if (this.mounted) {
          setState(() {
            this.zakatList = zakatList;
            this.count = zakatList.length;
          });
        }
      });
    });
  }

  Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context, int position) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation ?'),
          content: const Text('Are You sure you want to delete this entry?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                flag = 0;
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                flag = 1;
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
