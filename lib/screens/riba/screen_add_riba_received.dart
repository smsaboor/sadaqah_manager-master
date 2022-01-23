import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:sadaqah_manager/model/model_riba.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sadaqah_manager/model/model_setting.dart';

// Create a Form widget.
enum ConfirmAction { CANCEL, ACCEPT }

class AddRibaRecived extends StatefulWidget {
  final appBarTitle;
  final ModelRiba riba;
  String button;
  final finaluerid;
  int position;
  String currencyCode;
  ModelSetting settings;
  AddRibaRecived(this.riba, this.appBarTitle, this.button, this.finaluerid,
      this.position, this.currencyCode, this.settings);
  @override
  State<StatefulWidget> createState() {
    return AddRibaRecivedState(this.riba, this.appBarTitle, this.button,
        this.finaluerid, this.position, this.currencyCode, this.settings);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddRibaRecivedState extends State<AddRibaRecived> {
  String appBarTitle;
  ModelRiba riba;
  String button;
  final finaluserid;
  int position;
  String currencyCode;
  AddRibaRecivedState(this.riba, this.appBarTitle, this.button,
      this.finaluserid, this.position, this.currencyCode, this.settings);
  ModelSetting settings;
  DataHelper helper = DataHelper();
  bool _canShowButton = false;

  DateTime date;

  int flag = 0;
  List<ModelRiba> ribaList = List<ModelRiba>();
  DataHelper databaseHelper = DataHelper();

  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  final TextEditingController _controller3 = new TextEditingController();
  final TextEditingController _controller4 = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (riba.ribaId != null) {
      _controller1.text = riba.bankName.toString();
      _controller2.text = riba.amount.toString();
      _controller3.text = riba.date;
      _controller4.text = riba.note.toString();
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
//            autovalidate: _autoValidate,
              child: new SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                      controller: _controller1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter short description';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          hintText: 'Enter description',
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
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)),
                          labelText: 'Amount',
                          prefixText: ' ',
                          suffixText: currencyCode,
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
                            firstDate: DateTime.parse(settings.startDate),
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
                            splashColor: Colors.green,
                            color: Colors.red,
                            child: new Text(
                              button,
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                            onPressed: () async {
                              updateRibaListView();
                              final ConfirmAction action =
                                  await _asyncConfirmDialog(context, position);
                              if (flag == 1) {
                                _delete(context, ribaList[position]);
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
      this.riba.bankName = _controller1.text.toString();
      if (_controller2.text == null) {
        this.riba.amount = 0.0;
      } else {
        String amt = _controller2.text.toString();
        this.riba.amount = double.parse('$amt');
      }
      this.riba.date = _controller3.text.toString();
      this.riba.note = _controller4.text.toString();
      this.riba.userId = this.finaluserid;
      int result;
      if (riba.ribaId != null) {
        // Case 1: Update operation
        result = await helper.updateRiba(riba);
      } else {
        // Case 2: Insert Operation
        result = await helper.insertRiba(riba);
      }
      moveToLastScreen();
    }
  }

  void updateRibaListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelRiba>> ribaListFuture =
          databaseHelper.getRibaListReceived(finaluserid);
      ribaListFuture.then((ribaList) {
        setState(() {
          this.ribaList = ribaList;
        });
      });
    });
  }

  void _delete(BuildContext context, ModelRiba riba) async {
    int result = await databaseHelper.deleteRiba(riba.ribaId);
    if (result != 0) {
      _showSnackBar(context, 'Cash-in-Bank Deleted Successfully');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<ConfirmAction> _asyncConfirmDialog(
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
}
