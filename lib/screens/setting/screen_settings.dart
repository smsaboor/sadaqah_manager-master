import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/model/model_user.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:sadaqah_manager/util/country.dart';
import 'package:sadaqah_manager/util/utils/utils.dart';
import 'package:sadaqah_manager/util/country_pickers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sadaqah_manager/dto/metal_rates.dart';
import 'package:sadaqah_manager/helper/general_helper.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class AddSetting extends StatefulWidget {
  final appBarTitle;
  final ModelSetting setting;
  final finaluserid;

  AddSetting(this.setting, this.appBarTitle, this.finaluserid);

  @override
  State<StatefulWidget> createState() {
    return AddSettingState(this.setting, this.appBarTitle, this.finaluserid);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddSettingState extends State<AddSetting> {
  String symbolCurrency = '';
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('91');

  Country country;
  String appBarTitle;
  String button;
  ModelUser user;
  int deletePosition;
  final finaluserid;

  AddSettingState(this.settings, this.appBarTitle, this.finaluserid);

  DataHelper databaseHelper = DataHelper();
  ModelSetting settings;
  int flag = 0;
  int position;
  final TextEditingController _controller0 = new TextEditingController();
  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  final TextEditingController _nisabController = new TextEditingController();
  final TextEditingController _startDateController =
      new TextEditingController();
  final TextEditingController _endDateController = new TextEditingController();
  final TextEditingController _gold18Controller = new TextEditingController();
  final TextEditingController _gold20Controller = new TextEditingController();
  final TextEditingController _gold22Controller = new TextEditingController();
  final TextEditingController _gold24Controller = new TextEditingController();
  final TextEditingController _silver18Controller = new TextEditingController();
  final TextEditingController _silver20Controller = new TextEditingController();
  final TextEditingController _silver22Controller = new TextEditingController();
  final TextEditingController _silver24Controller = new TextEditingController();

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  Position _currentPosition;
  String _currentAddress;

  @override
  void initState() {
    updateListView();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.black26),
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
          ),
    );
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
                Icons.settings_backup_restore,
                size: 30,
              ),
              onPressed: () {
                _openResetDialog(context);
              },
            ),
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
                    padding: const EdgeInsets.only(top: 5.0),
                  ),
                  Text('    Country'),
                  Container(
                    margin: const EdgeInsets.all(1.0),
                    padding: const EdgeInsets.only(left: 5.0),
                    decoration: myBoxDecoration(),
                    height: 60,
                    //
                    width: 360,
                    //          <// --- BoxDecoration here
                    child: ListTile(
                      onTap: _openCountryPickerDialog,
                      title: _buildDialogItem(_selectedDialogCountry),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                  ),
                  new Text('    Select your Country.',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),

//                      new Padding(
//                        padding: const EdgeInsets.only(top: 5.0),
//                      ),
//                      Text('    Currency'),
//                      Container(
//                        margin: const EdgeInsets.all(1.0),
//                        padding: const EdgeInsets.only(left: 2.0),
//                        decoration: myBoxDecoration(),
//                        height: 60,
//                        //
//                        width: 360,
//                        //          <// --- BoxDecoration here
//                        child: ListTile(
//                          title: _buildDialogItemCurrency(_selectedDialogCountry),
//                        ),
//                      ),
//

                  new Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                  ),
                  Text('    Currency'),
                  Container(
                    margin: const EdgeInsets.all(1.0),
                    height: 60,
                    //
                    width: 370,
                    //          <// --- BoxDecoration here
                    child: new Theme(
                      data: new ThemeData(
                        primaryColor: Colors.redAccent,
                        primaryColorDark: Colors.red,
                      ),
                      child: new TextFormField(
                        controller: _controller0,
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            prefixText: ' ',
                            suffixText: '${symbolCurrency.toUpperCase()}',
                            suffixStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 18.0,
                            )),
                      ),
                    ),
                  ),

                  new Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                  ),
                  Text('    Nisab Amount'),
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.only(left: 0.0),
                    height: 60,
                    //
                    width: 370,
                    //          <// --- BoxDecoration here
                    child: new Theme(
                      data: new ThemeData(
                        primaryColor: Colors.redAccent,
                        primaryColorDark: Colors.red,
                      ),
                      child: new TextFormField(
                        controller: _nisabController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Nisab Amount';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp(
                              "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                        ],
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            hintText: 'Enter Nisab amount',
                            prefixText: ' ',
                            suffixText: '${symbolCurrency.toUpperCase()}',
                            suffixStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 16.0,
                            )),
                      ),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: new Text(
                        'Discuss with Muslim Scholars on how to calculate nisab (default: 85 gm 24 ct gold)',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                  ),
                  Text('    Zakat Period (354 Hijri days)'),
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.only(left: 5.0),
                    //decoration: myBoxDecoration(),
                    height: 80,
                    width: 380,
                    child: Row(
                      children: <Widget>[
                        Theme(
                          data: new ThemeData(
                            primaryColor: Colors.redAccent,
                            primaryColorDark: Colors.red,
                          ),
                          child: Expanded(
                            child: DateTimeField(
                              controller: _startDateController,
                              //editable: false,
                              validator: (value) {
                                if (_startDateController.text.length == 0) {
                                  return 'Enter Start date for Zakat.';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black26, width: 1.0),
                                ),
                                border: const OutlineInputBorder(),
                                labelText: 'Start Date',
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              format: DateFormat("yyyy-MM-dd"),
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(new Duration(days: 400)),
                                    lastDate: DateTime.now());
                              },
                              onChanged: (dt) {
                                setState() {}
                                _endDateController.text =
                                    new DateFormat("yyyy-MM-dd").format(
                                        dt.add(new Duration(days: 354)));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        new Expanded(
                          child: DateTimeField(
                            controller: _endDateController,
                            enabled: false,
                            validator: (value) {
                              if (_endDateController.text.length == 0) {
                                return 'Enter End date for Zakat.';
                              }
                              return null;
                            },
                            decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black26, width: 1.0),
                                ),
                                border: const OutlineInputBorder(),
                                hintText: 'End',
                                labelText: 'End Date',
                                labelStyle: const TextStyle(
                                  fontSize: 14.0,
                                ),
                                suffixStyle:
                                    const TextStyle(color: Colors.green)),
                            format: DateFormat("yyyy-MM-dd"),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  // TODO  firstDate must be greater than zakat start date
                                  firstDate: DateTime.now()
                                      .subtract(new Duration(days: 360)),
                                  lastDate: DateTime.now());
                            },
                            onChanged: (dt) {
                              if (_endDateController.text.length == 0) {
                                return 'Enter End date for Zakat.';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                  ),
                  new Text('    Select your Zakat applicable Year.',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                  ),
                  Text('    Gold Rates'),
                  Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.only(left: 5.0),
                    //decoration: myBoxDecoration(),
                    height: 80,
                    width: 380,
                    child: Row(
                      children: <Widget>[
                        Theme(
                          data: new ThemeData(
                            primaryColor: Colors.teal,
                            primaryColorDark: Colors.teal,
                          ),
                          child: Expanded(
                            child: new TextFormField(
                              controller: _gold18Controller,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Rate';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp(
                                    "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                              ],
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black26, width: 1.0),
                                ),
                                border: const OutlineInputBorder(),
                                labelText: '18 ct',
                                labelStyle: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        new Expanded(
                          child: new TextFormField(
                            controller: _gold20Controller,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Rate';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp(
                                  "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                            ],
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black26, width: 1.0),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: '20 ct',
                              labelStyle: const TextStyle(
                                color: Colors.green,
                                fontSize: 13.0,
                              ),
                              prefixText: ' ',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Theme(
                          data: new ThemeData(
                            primaryColor: Colors.green,
                            primaryColorDark: Colors.yellow,
                          ),
                          child: Expanded(
                            child: new TextFormField(
                              controller: _gold22Controller,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Rate';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp(
                                    "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                              ],
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black26, width: 1.0),
                                ),
                                border: const OutlineInputBorder(),
                                labelText: '22 ct',
                                labelStyle: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        new Expanded(
                          child: new TextFormField(
                            controller: _gold24Controller,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Rate';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp(
                                  "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                            ],
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black26, width: 1.0),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: '24 ct',
                              prefixText: ' ',
                              labelStyle: const TextStyle(
                                color: Colors.green,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                  ),
                  new Text(
                      '    Enter price of 1 Gram of Gold for each Carat value',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  new Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                  ),
                  Text('    Silver Rates'),
                  Container(
                    margin: const EdgeInsets.all(1.0),
                    padding: const EdgeInsets.only(left: 5.0),
                    //decoration: myBoxDecoration(),
                    height: 80,
                    width: 390,
                    //          <// --- BoxDecoration here
                    child: Row(
                      children: <Widget>[
                        Theme(
                          data: new ThemeData(
                            primaryColor: Colors.redAccent,
                            primaryColorDark: Colors.red,
                          ),
                          child: Expanded(
                            child: new TextFormField(
                              controller: _silver18Controller,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Rate';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp(
                                    "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                              ],
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black26, width: 1.0),
                                ),
                                border: const OutlineInputBorder(),
                                labelText: '18 ct',
                                labelStyle: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        new Expanded(
                          child: new TextFormField(
                            controller: _silver20Controller,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Rate';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp(
                                  "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                            ],
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black26, width: 1.0),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: '20 ct',
                              labelStyle: const TextStyle(
                                color: Colors.green,
                                fontSize: 13.0,
                              ),
                              prefixText: ' ',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Theme(
                          data: new ThemeData(
                            primaryColor: Colors.redAccent,
                            primaryColorDark: Colors.red,
                          ),
                          child: Expanded(
                            child: new TextFormField(
                              controller: _silver22Controller,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter Rate';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp(
                                    "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                              ],
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black26, width: 1.0),
                                ),
                                border: const OutlineInputBorder(),
                                labelText: '22 ct',
                                labelStyle: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        new Expanded(
                          child: new TextFormField(
                            controller: _silver24Controller,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Rate';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp(
                                  "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$"))
                            ],
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black26, width: 1.0),
                              ),
                              border: const OutlineInputBorder(),
                              labelText: '24 ct',
                              labelStyle: const TextStyle(
                                color: Colors.green,
                                fontSize: 13.0,
                              ),
                              prefixText: ' ',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                  ),
                  new Text(
                      '    Enter price of 1 Gram of Silver for each Carat value',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )),
            )));
  }

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(
            width: 8.0,
          ),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

  Widget _buildDialogItemCurrency(Country country) => Row(
        children: <Widget>[
          Flexible(
            child: Text(
                '${country.currencyName} (${country.currencyCode})                                 ${country.currencySymbol}'),
            flex: 300,
          ),
        ],
      );

  void moveToLastScreen() {
    Navigator.pop(context);
  }

// Update the title of User object

  void _save() async {
    if (formKey.currentState.validate()) {
      //updateListView();
      if (this.settings == null) {
        this.settings = new ModelSetting();
      }
      this.settings.country = _selectedDialogCountry.isoCode;
      this.settings.currency = _selectedDialogCountry.currencyCode;

      if (_nisabController.text == null) {
        this.settings.nisab = 0.0;
      } else {
        String nisab = _nisabController.text.toString();
        this.settings.nisab = double.parse('$nisab');
      }
      this.settings.startDate = _startDateController.text.toString();
      this.settings.endDate = _endDateController.text.toString();

      if (_gold18Controller.text == null) {
        this.settings.goldRate18C = 0.0;
      } else {
        String gld = _gold18Controller.text.toString();
        this.settings.goldRate18C = double.parse('$gld');
      }

      if (_gold20Controller.text == null) {
        this.settings.goldRate20C = 0.0;
      } else {
        String gld = _gold20Controller.text.toString();
        this.settings.goldRate20C = double.parse('$gld');
      }

      if (_gold22Controller.text == null) {
        this.settings.goldRate22C = 0.0;
      } else {
        String gld = _gold22Controller.text.toString();
        this.settings.goldRate22C = double.parse('$gld');
      }
      if (_gold24Controller.text == null) {
        this.settings.goldRate24C = 0.0;
      } else {
        String gld = _gold24Controller.text.toString();
        this.settings.goldRate24C = double.parse('$gld');
      }

      if (_silver18Controller.text == null) {
        this.settings.silverRate18C = 0.0;
      } else {
        String slv = _silver18Controller.text.toString();
        this.settings.silverRate18C = double.parse('$slv');
      }
      if (_silver20Controller.text == null) {
        this.settings.silverRate20C = 0.0;
      } else {
        String slv = _silver20Controller.text.toString();
        this.settings.silverRate20C = double.parse('$slv');
      }
      if (_silver22Controller.text == null) {
        this.settings.silverRate22C = 0.0;
      } else {
        String slv = _silver22Controller.text.toString();
        this.settings.silverRate22C = double.parse('$slv');
      }
      if (_silver24Controller.text == null) {
        this.settings.silverRate24C = 0.0;
      } else {
        String slv = _silver24Controller.text.toString();
        this.settings.silverRate24C = double.parse('$slv');
      }

      int result;
      if (settings.settingId != null) {
        // Case 1: Update operation
        result = await databaseHelper.updateSetting(settings);
      } else {
        // Case 2: Insert Operation
        result = await databaseHelper.insertSetting(settings);
      }
      moveToLastScreen();
    }
  } //Save function end

  void _openResetDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Confirm Settings Reset";
        String message =
            "The setting values will be restored to today's data. Are you sure you want to reset your current settings?";
        String btnLabel = "OK";
        String btnLabelCancel = "Cancel";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _restore(context),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              )
            : new AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabel),
                    onPressed: () => _restore(context),
                  ),
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
      },
    );
  }

  void _restore(BuildContext context) async {
    _getCurrentLocation();
    Navigator.pop(context);
  }

  void updateListView() {
    Future<ModelSetting> settingListFuture =
        databaseHelper.getSettingList(this.finaluserid);
    settingListFuture.then((settingList) {
      setState(() {
        this.settings = settingList;
        _nisabController.text = settingList.nisab.toStringAsFixed(2);
        _startDateController.text = settingList.startDate;
        _endDateController.text = settingList.endDate;

        _gold18Controller.text = settingList.goldRate18C.toString();
        _gold20Controller.text = settingList.goldRate20C.toString();
        _gold22Controller.text = settingList.goldRate22C.toString();
        _gold24Controller.text = settingList.goldRate24C.toString();

        _silver18Controller.text = settingList.silverRate18C.toString();
        _silver20Controller.text = settingList.silverRate20C.toString();
        _silver22Controller.text = settingList.silverRate22C.toString();
        _silver24Controller.text = settingList.silverRate24C.toString();

        _selectedDialogCountry =
            CountryPickerUtils.getCountryByIsoCode(settingList.country);
        _controller0.text = _selectedDialogCountry.currencyName +
            ' (' +
            _selectedDialogCountry.currencyCode +
            ')';
        symbolCurrency = _selectedDialogCountry.currencySymbol;
      });
    });
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: Text('Select/Search Your Country'),
                onValuePicked: (Country country) {
                  setState(() {
                    _selectedDialogCountry = country;
                    _controller0.text = _selectedDialogCountry.currencyName +
                        ' (' +
                        _selectedDialogCountry.currencyCode +
                        ')';
                    symbolCurrency = _selectedDialogCountry.currencySymbol;
                    _controller2.text =
                        '(${_selectedDialogCountry.currencySymbol}) ${_selectedDialogCountry.currencyName}';
                    updateMetalRates();
                  });
                },
                itemBuilder: _buildDialogItem)),
      );

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

      await Geolocator.getCurrentPosition()
          .then((Position position) {
        //setState(() {
        _currentPosition = position;
        //});
        _getAddressFromLatLng();
      }).catchError((e) {
        print(e);
        final snackBar = SnackBar(
          content: Text('Unable to fetch location.'),
          duration: Duration(seconds: 5),
        );

        scaffoldKey.currentState.showSnackBar(snackBar);
      });

  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        _selectedDialogCountry =
            CountryPickerUtils.getCountryByIsoCode(place.isoCountryCode);

        symbolCurrency = _selectedDialogCountry.currencySymbol;
        _controller0.text = _selectedDialogCountry.currencyName +
            ' (' +
            _selectedDialogCountry.currencyCode +
            ')';
        _controller2.text =
            '(${_selectedDialogCountry.currencySymbol}) ${_selectedDialogCountry.currencyName}';

        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Current Location: $_currentAddress'),
          duration: Duration(seconds: 5),
        ));
        updateMetalRates();
      });
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
        content: Text('Unable to fetch geo-location.'),
        duration: Duration(seconds: 5),
      );

      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void updateMetalRates() {
    Future<MetalRates> metalRates =
        GeneralHelper.fetchMetalRates(_selectedDialogCountry.currencyCode);
    metalRates.then((rate) {
      setState(() {
        // Convert 18 Karat, 18/24= 0.750
        _gold18Controller.text = (rate.goldRate * 0.750).toString();
        // Convert 20 Karat, 20/24= 0.833
        _gold20Controller.text = (rate.goldRate * 0.833).toString();
        // Convert 22 Karat, 22/24= 0.916
        _gold22Controller.text = (rate.goldRate * 0.916).toString();
        _gold24Controller.text = rate.goldRate.toString();
        _nisabController.text = rate.goldRate != null
            ? '${(rate.goldRate * 85).toStringAsFixed(2)}' //85gm of gold is the nisab threshold
            : '0';
        _silver18Controller.text = (rate.silverRate * 0.750).toString();
        _silver20Controller.text = (rate.silverRate * 0.833).toString();
        _silver22Controller.text = (rate.silverRate * 0.916).toString();
        _silver24Controller.text = rate.silverRate.toString();
      });
    }).catchError((error) {
      print(error);
      final snackBar = SnackBar(
        content: Text('Unable to fetch gold and silver rates.'),
        duration: Duration(seconds: 5),
      );

      scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );

  void _openFilteredCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: Text('Select your phone code'),
                onValuePicked: (Country country) =>
                    setState(() => _selectedDialogCountry = country),
                itemFilter: (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
                itemBuilder: _buildDialogItem)),
      );

  Widget _buildCupertinoSelectedItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Text("+${country.phoneCode}"),
        SizedBox(width: 8.0),
        Flexible(child: Text(country.name))
      ],
    );
  }

  Widget _buildCupertinoItem(Country country) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: CupertinoColors.white,
        fontSize: 16.0,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 8.0),
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      ),
    );
  }
}

//end
