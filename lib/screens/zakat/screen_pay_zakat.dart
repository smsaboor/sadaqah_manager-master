import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:sadaqah_manager/model/model_zakat_paid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/util/utils/utils.dart';

// Create a Form widget.
enum ConfirmAction { CANCEL, ACCEPT }

class AddZakatPayment extends StatefulWidget {
  final appBarTitle;
  final ModelZakatPaid zakatPayment;
  String button;
  final finaluserid;
  int position;
  ModelSetting settings;
  double zakatBalance;
  AddZakatPayment(this.zakatPayment, this.appBarTitle, this.button,
      this.finaluserid, this.position, this.settings, this.zakatBalance);
  @override
  State<StatefulWidget> createState() {
    return AddZakatPaymentState(
        this.zakatPayment,
        this.appBarTitle,
        this.button,
        this.finaluserid,
        this.position,
        this.settings,
        this.zakatBalance);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddZakatPaymentState extends State<AddZakatPayment> {
  int position;
  final finaluserid;
  String appBarTitle;
  String button;
  ModelZakatPaid zakatPayment;
  double zakatBalance;
  AddZakatPaymentState(this.zakatPayment, this.appBarTitle, this.button,
      this.finaluserid, this.position, this.settings, this.zakatBalance);

  bool _canShowButton = false;
  DateTime date;
  int flag = 0;
  ModelSetting settings;
  String currencySymbol;
  DataHelper databaseHelper = DataHelper();
  List<ModelZakatPaid> paymentList = List<ModelZakatPaid>();
  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  final TextEditingController _controller3 = new TextEditingController();
  final TextEditingController _controller4 = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    this.currencySymbol =
        CountryPickerUtils.getCountryByIsoCode('${settings.country}')
            .currencySymbol;
    if (zakatPayment.zakatPaymentId != null) {
      _controller1.text = zakatPayment.title.toString();
      _controller2.text = zakatPayment.amount.toString();
      _controller3.text = zakatPayment.paymentDate.toString();
      _controller4.text = zakatPayment.note.toString();
      _canShowButton = true;
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyText1;

    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          backgroundColor: Colors.red,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                moveToLastScreen();
              }),
          title: new Text(appBarTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                size: 30,
              ),
              onPressed: () {
                _save();
              },
            )
          ],
        ),
        body: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Form(
              key: formKey,
              child: new SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.redAccent,
                      primaryColorDark: Colors.red,
                    ),
                    child: new TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _controller1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter short description';
                        }
                        return null;
                      },
                      onFieldSubmitted: (title) {
                        setState(() {
                          _controller1.text = title.toString();
                        });
                      },
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          hintText:
                              'Short description to identify this payment',
//                                        helperText: 'Keep it short, This is a Title for about Your payment.',
                          labelText: 'Title',
                          prefixText: ' ',
                          suffixIcon: Icon(Icons.title, color: Colors.red),
                          suffixStyle: const TextStyle(color: Colors.green)),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.redAccent,
                      primaryColorDark: Colors.red,
                    ),
                    child: new TextFormField(
                      controller: _controller2,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Amount';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp(
                            "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          labelText: 'Amount',
                          prefixText: ' ',
                          suffixText: ' $currencySymbol',
                          suffixStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 18.0,
                          )),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.redAccent,
                      primaryColorDark: Colors.red,
                    ),
                    child: DateTimeField(
                      controller: _controller3,
                      validator: (value) {
                        if (value == null &&
                            (_controller3.text == null ||
                                _controller3.text.isEmpty)) {
                          return 'Enter date';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          hintText: 'Select Date',
                          labelText: 'Date',
                          labelStyle: const TextStyle(fontSize: 20.0),
                          suffixText: 'YYYY-MM-DD',
                          prefixIcon: Icon(Icons.date_range, color: Colors.red),
                          suffixStyle: const TextStyle(color: Colors.green)),
                      format: DateFormat("yyyy-MM-dd"),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            initialDate: currentValue ?? DateTime.now(),
                            // TODO  firstDate must be greater than zakat start date
                            firstDate: DateTime.now()
                                .subtract(new Duration(days: 360)),
                            lastDate: DateTime.now());
                      },
                      onChanged: (dt) {
                        //_controller3.text = dt.toString();
                      },
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.redAccent,
                      primaryColorDark: Colors.red,
                    ),
                    child: new TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLines: 6,
                      controller: _controller4,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          labelText: 'Note',
                          prefixText: ' ',
                          suffixIcon: Icon(
                            Icons.note,
                            color: Colors.red,
                          ),
                          suffixStyle: const TextStyle(color: Colors.green)),
                    ),
                  ),
                  SizedBox(
                    width: 100.0,
                    height: 100.0,
                  ),
                  new SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: _canShowButton
                        ? RaisedButton(
                            color: Colors.red,
                            child: new Text(
                              button,
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                            onPressed: () async {
                              updateListView();
                              final ConfirmAction action =
                                  await _asyncConfirmDialog(context, position);
                              if (flag == 1) {
                                _delete(context, paymentList[position]);
                                moveToLastScreen();
                              }
                            },
                          )
                        : SizedBox(),
                  ),
                ],
              )),
            )));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _save() async {
    if (formKey.currentState.validate()) {
      this.zakatPayment.title = _controller1.text.toString();
      if (_controller2.text == null) {
        this.zakatPayment.amount = 0.0;
      } else {
        String amt = _controller2.text.toString();
        this.zakatPayment.amount = double.parse('$amt');
      }
      if (this.zakatPayment.amount > this.zakatBalance) {
        _showSnackBar(context,
            'Amount entered is more than the zakat balance to be paid! Please review the value',
            textColor: Colors.red);
        return;
      }
      this.zakatPayment.paymentDate = _controller3.text.toString();
      this.zakatPayment.note = _controller4.text.toString();
      this.zakatPayment.userId = this.finaluserid;
      if (zakatPayment.zakatPaymentId != null) {
        await databaseHelper.updateZakatPaid(zakatPayment);
      } else {
        await databaseHelper.insertZakatPaid(zakatPayment);
      }
      moveToLastScreen();
    }
  }

  void _delete(BuildContext context, ModelZakatPaid zakatPaid) async {
    int result = await databaseHelper.deleteZakatPaid(zakatPaid.zakatPaymentId);
    if (result != 0) {
      _showSnackBar(context, 'Payment Deleted Successfully');
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {Color textColor: Colors.white}) {
    final snackBar =
        SnackBar(content: Text(message, style: TextStyle(color: textColor)));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<ConfirmAction> _asyncConfirmDialog(
      BuildContext context, int position) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation ?'),
          content: const Text('Are you sure you want to delete this entry?'),
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

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelZakatPaid>> zakatPaidListFuture =
          databaseHelper.getZakatPaidList(finaluserid);
      zakatPaidListFuture.then((zakatPaidList) {
        setState(() {
          this.paymentList = zakatPaidList;
        });
      });
    });
  }
}
