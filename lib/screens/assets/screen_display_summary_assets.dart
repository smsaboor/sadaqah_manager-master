import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sadaqah_manager/model/model_metal.dart';
import 'package:sadaqah_manager/model/model_cash.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/util/country.dart';
import 'package:sadaqah_manager/util/country_pickers.dart';

class DisplayAllAssets extends StatefulWidget {
  final String appBarTitle;
  final String page;
  final finaluserid;
  final ModelSetting settings;

  DisplayAllAssets(
      this.appBarTitle, this.page, this.finaluserid, this.settings);
  @override
  State<StatefulWidget> createState() {
    return DisplayAllAssetsState(
        this.appBarTitle, this.page, this.finaluserid, this.settings);
  }
}

class DisplayAllAssetsState extends State<DisplayAllAssets> {
  String appBarTitle;
  String page;
  final finaluserid;
  final ModelSetting settings;

  DisplayAllAssetsState(
      this.appBarTitle, this.page, this.finaluserid, this.settings);

  DataHelper databaseHelper = DataHelper();
  List<ModelCash> cashList;
  List<ModelMetal> metalList;
  Country _selectedDialogCountry;
  double totalCashInHand = 0;
  double totalCashInBank = 0;
  double totalGold = 0;
  double totalSilver = 0;
  double totalAllAssets = 0;

  @override
  void initState() {
    _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode(settings.country);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cashList == null) {
      cashList = List<ModelCash>();
      metalList = List<ModelMetal>();
      updateListViewCash('cash', 'cashinhand', this.finaluserid);
      updateListViewCash('cash', 'cashinbank', this.finaluserid);
      updateListViewMetal('metal', 'gold', this.finaluserid);
      updateListViewMetal('metal', 'silver', this.finaluserid);

      getAllTotal();
    }

    return Column(
      children: <Widget>[
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
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Text(_selectedDialogCountry.currencySymbol,
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
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Text(_selectedDialogCountry.currencySymbol,
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
                child: Text('Total Gold Value',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalGold.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Text(_selectedDialogCountry.currencySymbol,
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
                child: Text('Total Silver Value',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalSilver.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Text(_selectedDialogCountry.currencySymbol,
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Divider(
          color: Colors.black,
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
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Text(_selectedDialogCountry.currencySymbol,
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
      ],
    );
  }

  // functions for Cash.................................................
  void updateListViewCash(String table, String type, int finaluserid) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelCash>> cashListFuture = databaseHelper.getCashList(
          finaluserid, table, type, settings.startDate, settings.endDate);
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

  // functions for metal.................................................
  void updateListViewMetal(String table, String type, int finaluserid) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ModelMetal>> cashListFuture =
          databaseHelper.getMetalList(finaluserid, table, type);
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
    double gTtotalAmountGold = 0.0;
    double totalAmount18CS = 0.0;
    double totalAmount20CS = 0.0;
    double totalAmount22CS = 0.0;
    double totalAmount24CS = 0.0;
    double gTtotalAmountSilver = 0.0;
    double totalAmount = 0.0;
    if (metal == 'gold') {
      for (int i = 0; i <= metalList.length - 1; i++) {
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
      totalAmount18CG = totalWeight18CG * this.settings.goldRate18C;
      totalAmount20CG = totalWeight20CG * this.settings.goldRate20C;
      totalAmount22CG = totalWeight22CG * this.settings.goldRate22C;
      totalAmount24CG = totalWeight24CG * this.settings.goldRate24C;
      gTtotalAmountGold =
          totalAmount18CG + totalAmount20CG + totalAmount22CG + totalAmount24CG;
      totalAmount = gTtotalAmountGold;
    } else {
      for (int i = 0; i <= metalList.length - 1; i++) {
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
      totalAmount18CS = totalWeight18CS * this.settings.silverRate18C;
      totalAmount20CS = totalWeight20CS * this.settings.silverRate20C;
      totalAmount22CS = totalWeight22CS * this.settings.silverRate22C;
      totalAmount24CS = totalWeight24CS * this.settings.silverRate24C;
      gTtotalAmountSilver =
          totalAmount18CS + totalAmount20CS + totalAmount22CS + totalAmount24CS;
      totalAmount = gTtotalAmountSilver;
    }
    return totalAmount;
  }

  double getAllTotal() {
    double allTotal = 0;
    allTotal = totalCashInHand + totalCashInBank + totalGold + totalSilver;
    return allTotal;
  }
}
