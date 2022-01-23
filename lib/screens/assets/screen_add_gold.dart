import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sadaqah_manager/model/model_metal.dart';
import 'package:sadaqah_manager/model/model_user.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:sqflite/sqflite.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class AddGold extends StatefulWidget {
  final appBarTitle;
  final ModelMetal metal;
  String button;
  int deletePosition;
  final finaluserid;
  int position;
  AddGold(this.metal, this.appBarTitle, this.button, this.deletePosition,
      this.finaluserid, this.position);
  @override
  State<StatefulWidget> createState() {
    return AddGoldState(this.metal, this.appBarTitle, this.button,
        this.deletePosition, this.finaluserid, this.position);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddGoldState extends State<AddGold> {
  String appBarTitle;
  String button;
  ModelUser user;
  int deletePosition;
  ModelMetal metal;
  int flag = 0;
  int position;
  DataHelper databaseHelper = DataHelper();
  List<ModelMetal> metalList = List<ModelMetal>();
  final finaluserid;

  AddGoldState(this.metal, this.appBarTitle, this.button, this.deletePosition,
      this.finaluserid, this.position);
  bool _canShowButton = false;
  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  final TextEditingController _controller3 = new TextEditingController();
  final TextEditingController _controller4 = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (metal.metalId != null) {
      _controller1.text = metal.item;
      _controller2.text = metal.weight.toString();
      _controller3.text = metal.date;
      _controller4.text = metal.note;
      if (metal.carat == 18) {
        _currentSelectedValue = '18K';
      } else if (metal.carat == 20) {
        _currentSelectedValue = '20K';
      } else if (metal.carat == 22) {
        _currentSelectedValue = '22K';
      } else if (metal.carat == 24) {
        _currentSelectedValue = '24K';
      }

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

  var _caratList = ['18K', '20K', '22K', '24K'];
  String _currentSelectedValue = '24K';

  @override
  Widget build(BuildContext context) {
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
                  child: new Column(
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
                          hintText: 'Short description to identify the item',
//                                            helperText: 'Keep it short, this is your Gold item name.',
                          labelText: 'Item Description',
                          prefixText: ' ',
                          suffixIcon: Icon(Icons.title, color: Colors.red),
                          suffixStyle: const TextStyle(color: Colors.green)),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  Row(
                    children: <Widget>[
                      Theme(
                        data: new ThemeData(
                          primaryColor: Colors.redAccent,
                          primaryColorDark: Colors.red,
                        ),
                        child: new Flexible(
                          child: TextFormField(
                            controller: _controller2,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter weight';
                              }
                              return null;
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp(
                                  "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                            ],
                            decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                labelText: 'Weight',
                                prefixText: ' ',
                                suffixText: "gm",
                                hintText: 'Weight in Grams',
                                hintStyle: const TextStyle(fontSize: 14.0),
                                suffixStyle: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18.0,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      new Flexible(
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                  labelText: 'Carat',
                                  labelStyle: new TextStyle(
                                      color: Colors.black54, fontSize: 16.0),
                                  errorStyle: TextStyle(
                                      color: Colors.redAccent, fontSize: 8.0),
                                  hintText: 'Please select carat',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                              isEmpty: _currentSelectedValue == '',
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _currentSelectedValue,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _currentSelectedValue = newValue;
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: _caratList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                          hintText:
                              'Date when the item came in your possession',
                          labelStyle: const TextStyle(fontSize: 20.0),
                          labelText: 'Date of Purchase',
                          suffixText: 'YYYY-MM-DD',
                          prefixIcon: Icon(Icons.date_range, color: Colors.red),
                          suffixStyle: const TextStyle(color: Colors.green)),
                      format: DateFormat("yyyy-MM-dd"),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            initialDate: currentValue ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());
                      },
                      onChanged: (dt) {
                        //_controller3.text = dt.toString();
                      },
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: new Text(
                        'Gold item will be considered for zakat if it crosses 1 hijri year of possession',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                    height: 80.0,
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
                              updateListViewG();
                              final ConfirmAction action =
                                  await _asyncConfirmDialog(context, position);
                              if (flag == 1) {
                                _delete(context, metalList[position]);
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

// Update the title of User object

  void _save() async {
    if (formKey.currentState.validate()) {
      this.metal.item = _controller1.text.toString();
      if (_controller2.text == null) {
        this.metal.weight = 0.0;
      } else {
        String wgt = _controller2.text.toString();
        this.metal.weight = double.parse('$wgt');
      }

      if (_currentSelectedValue == '18K') this.metal.carat = 18.0;
      if (_currentSelectedValue == '20K')
        this.metal.carat = 20.0;
      else if (_currentSelectedValue == '22K')
        this.metal.carat = 22.0;
      else if (_currentSelectedValue == '24K') this.metal.carat = 24.0;
      this.metal.date = _controller3.text.toString();
      this.metal.type = 'gold';
      this.metal.note = _controller4.text.toString();
      this.metal.userId = this.finaluserid;

      if (metal.metalId != null) {
        // Case 1: Update operation
        await databaseHelper.updateMetal(metal);
      } else {
        // Case 2: Insert Operation
        await databaseHelper.insertMetal(metal);
      }

      moveToLastScreen();
    }
  } //Save function end

  void _delete(BuildContext context, ModelMetal metal) async {
    int result = await databaseHelper.deleteMetal(metal.metalId);
    if (result != 0) {
      _showSnackBar(context, 'Gold Asset Deleted Successfully');
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
          title: Text('Delete Confirmation?'),
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

  void updateListViewG() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelMetal>> metalListFuture =
          databaseHelper.getMetalList(finaluserid, 'metal', 'gold');
      metalListFuture.then((metalList) {
        setState(() {
          this.metalList = metalList;
        });
      });
    });
  }
}
