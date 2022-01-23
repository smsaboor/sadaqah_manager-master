import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/model/model_zakat_paid.dart';
import 'package:sadaqah_manager/screens/zakat/tab_summary.dart';
import 'package:sadaqah_manager/screens/zakat/tab_payments.dart';
import 'package:sadaqah_manager/screens/zakat/screen_pay_zakat.dart';

class Zakat extends StatefulWidget {
  final appBarTitle;
  final page;
  int userId;
  ModelZakatPaid zakatPaid;
  ModelSetting settings;
  Zakat(
      this.zakatPaid, this.appBarTitle, this.page, this.userId, this.settings);

  @override
  State<StatefulWidget> createState() {
    return ZakatState(this.zakatPaid, this.appBarTitle, this.page, this.userId,
        this.settings);
  }
}

class ZakatState extends State<Zakat> with SingleTickerProviderStateMixin {
  final appBarTitle;
  final page;
  int userId;
  ModelSetting settings;
  double zakatBalance = 0;
  ModelZakatPaid zakatPaid;
  TabController tabController;

  ZakatState(
      this.zakatPaid, this.appBarTitle, this.page, this.userId, this.settings);

  int tabIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 2)..addListener((){

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
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
                Tab(child: Text('PAYMENTS')),
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
                  child: DisplayZakatSummary(
                      ModelZakatPaid('$tabIndex', '', '', '', 0.0, '', this.userId),
                      'Summary',
                      'Zakat',
                      this.userId,
                      this.settings,
                      setZakatBalance),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  // Change the color of the container beneath
                },
                child: Container(
                  child: DisplayZakatPaid(
                      'Payments', 'page', userId, settings, getZakatBalance),
                ),
              ),
            ],
          ),
//          floatingActionButton: FloatingActionButton(
//            onPressed: () {
//              if (this.zakatBalance <= 0) {
//                _showAlertDialog(
//                    'Pay Zakat', 'There is no zakat due on your wealth');
//              } else {
//                Navigator.of(context)
//                    .push(new MaterialPageRoute(
//                        builder: (_) => AddZakatPayment(
//                              ModelZakatPaid(
//                                  '', '', '', '', 0, '', this.userId),
//                              'Pay Zakat',
//                              'Save',
//                              this.userId,
//                              0,
//                              this.settings,
//                              this.zakatBalance,
//                            )))
//                    .then((val) => {
//                      setState((){
//                        this.userId=userId;
//                      })
//                });
//              }
//            },
//            child: Text('Pay'),
//            backgroundColor: Colors.red,
//          ),
//          floatingActionButtonLocation:
//              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void setZakatBalance(double zakatBalance) {
    this.zakatBalance = zakatBalance;
  }

  double getZakatBalance(){
    return zakatBalance;
  }
}
