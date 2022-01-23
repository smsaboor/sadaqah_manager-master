import 'package:flutter/cupertino.dart';
import 'package:sadaqah_manager/model/model_riba.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/model/model_user.dart';
import 'package:sadaqah_manager/model/model_zakat_paid.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sadaqah_manager/model/model_cash.dart';
import 'package:sadaqah_manager/model/model_metal.dart';
import 'package:sadaqah_manager/model/model_loan.dart';

class DataHelper {
  //--------------------------- Common implementation for all Assets (Gold, Silver, Cash-in-hand, Cash-in-Bank)------------
  static DataHelper _databaseHelper; // Define Singleton DatabaseHelper object
  static Database _database; // Define Singleton Database object
  static var total;
  DataHelper._createInstance();
  factory DataHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DataHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'sadakaahManager35.db';
    var assetDatabase = await openDatabase(path,
        version: 3,
        onCreate: _createDb,
        onUpgrade: _upgradeDb,
        onOpen: _openDb);

    return assetDatabase;
  }

  var resultsettion;
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE user(userId INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT NOT NULL UNIQUE, password TEXT, registrationDate TEXT, isPaid TEXT, age INTEGER, paymentDate TEXT, city TEXT, pin INTEGER, familyId  INTEGER, photoUrl TEXT)');
    await db.execute(
        'CREATE TABLE setting2(settingId INTEGER PRIMARY KEY AUTOINCREMENT, country TEXT, currency TEXT, nisab DOUBLE, startDate TEXT, endDate TEXT, goldRate18C DOUBLE, goldRate20C DOUBLE, goldRate22C DOUBLE, goldRate24C DOUBLE, silverRate18C DOUBLE, silverRate20C DOUBLE, silverRate22C DOUBLE, silverRate24C DOUBLE, userId INTEGER)');
    await db.execute(
        'CREATE TABLE zakatPayments(zakatPaymentId INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, startDate TEXT, endDate TEXT, paymentDate TEXT, amount DOUBLE, note TEXT, userId INTEGER)');
    await db.execute(
        'CREATE TABLE riba(ribaId INTEGER PRIMARY KEY AUTOINCREMENT, bankName TEXT, amount DOUBLE, date TEXT, note TEXT, userId INTEGER)');
    await db.execute(
        'CREATE TABLE cash(cashId INTEGER PRIMARY KEY AUTOINCREMENT,  title TEXT, amount DOUBLE,  date TEXT, note TEXT, type INTEGER, userId INTEGER)');
    await db.execute(
        'CREATE TABLE metal(metalId INTEGER PRIMARY KEY AUTOINCREMENT, item TEXT, weight DOUBLE,carat DOUBLE, date TEXT, note TEXT, type TEXT, userId INTEGER)');
    await db.execute(
        'CREATE TABLE loan(loanid INTEGER PRIMARY KEY AUTOINCREMENT,  description TEXT, amount DOUBLE, date TEXT, type TEXT,addnotes TEXT, userId INTEGER)');
  }

  void _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      await db.execute("DROP TABLE IF EXISTS zakatPayed");
      await db.execute("DROP TABLE IF EXISTS zakat");
      await db.execute(
          'CREATE TABLE zakatPayments(zakatPaymentId INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, startDate TEXT, endDate TEXT, paymentDate TEXT, amount DOUBLE, note TEXT, userId INTEGER)');
    }
    if (oldVersion <= 2) {
      await db.execute("ALTER TABLE metal RENAME TO tmp_metal");
      await db.execute(
          'CREATE TABLE metal(metalId INTEGER PRIMARY KEY AUTOINCREMENT, item TEXT, weight DOUBLE,carat DOUBLE, date TEXT, note TEXT, type TEXT, userId INTEGER)');
      await db.execute(
          "INSERT INTO metal(metalId, item, weight, carat, date, note, type, userId) SELECT metalId, item, weight, carat, dateOfPurchase, note, type, userId FROM tmp_metal");
      await db.execute("DROP TABLE tmp_metal");
      await db.execute("ALTER TABLE user ADD COLUMN name TEXT");
      await db.execute("ALTER TABLE user ADD COLUMN photoUrl TEXT");
    }
  }

  void _openDb(Database db) async {
    //await db.execute("ALTER TABLE user ADD COLUMN name TEXT");
    //await db.execute("ALTER TABLE user ADD COLUMN photoUrl TEXT");
    debugPrint('Open Database called @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
  }
  //---------------------------- All Functions for Cash Asset are implemented below-----------------------------------

  Future<List<Map<String, dynamic>>> getMapList(int userId, String table,
      String type, String startDate, String endDate) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $table WHERE type=? AND userId=? and date between "$startDate" AND "$endDate"',
        ['$type', '$userId']);
    return result;
  }

  Future<List<Map<String, dynamic>>> getMapList2(
      String table, String type) async {
    Database db = await this.database;
    var result2 = await db.rawQuery(
        'SELECT SUM(amount) as Mysum FROM $table WHERE type=?', ['$type']);
    return result2;
  }

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelCash>> getCashList(int userId, String table, String type,
      String startDate, String endDate) async {
    var metalMapList = await getMapList(userId, table, type, startDate,
        endDate); // first Get 'Map List' from database
    int count = metalMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelCash> metalList =
        List<ModelCash>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      metalList.add(ModelCash.fromMapObject(metalMapList[i]));
    }
    return metalList; // finally return our Users list
  }

  Future<int> insertCash(ModelCash cash) async {
    Database db = await this.database;
    var result = await db.insert('cash', cash.toMap());
    return result;
  }

  Future<int> updateCash(ModelCash cash) async {
    var db = await this.database;
    var result = await db.update('cash', cash.toMap(),
        where: 'cashId = ?', whereArgs: [cash.cashId]);
    return result;
  }

  Future<int> deleteCash(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM cash WHERE cashId = $id');
    return result;
  }

  Future<int> getCashCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from cash');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //------------------------------All Functions For Metal Asset are implemented below------------------------------------------

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]

  Future<List<ModelMetal>> getMetalList(int userId, String table, String type,
      {String startDate = '1900-01-01', String endDate = '3000-01-01'}) async {
    var metalMapList = await getMapList(userId, table, type, startDate,
        endDate); // first Get 'Map List' from database
    int count = metalMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelMetal> metalList =
        List<ModelMetal>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      metalList.add(ModelMetal.fromMapObject(metalMapList[i]));
    }
    return metalList; // finally return our Users list
  }

  Future<int> insertMetal(ModelMetal metal) async {
    Database db = await this.database;
    var result = await db.insert('metal', metal.toMap());
    return result;
  }

  Future<int> updateMetal(ModelMetal metal) async {
    var db = await this.database;
    var result = await db.update('metal', metal.toMap(),
        where: 'metalId = ?', whereArgs: [metal.metalId]);
    return result;
  }

  Future<int> deleteMetal(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM metal WHERE metalId = $id');
    return result;
  }

  Future<int> getMetalCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from metal');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

//-------------------------------------------------------------------------------------------------------
//---------------------------- All Functions for User Table are implemented below---------------------------------
// Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]

  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM user');
    return result;
  }

  Future<List<ModelUser>> getUserList() async {
    var userMapList =
        await getUserMapList(); // first Get 'Map List' from database
    int count = userMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelUser> userList =
        List<ModelUser>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      userList.add(ModelUser.fromMapObject(userMapList[i]));
    }
    int lnght = userList.length;
    String lenght = lnght.toString();
    for (int i = 0; i <= userList.length - 1; i++) {
      debugPrint(lenght);
    }
    return userList; // finally return our Users list
  }

  Future<List<Map<String, dynamic>>> getUserAuthenticationMapList(
      String paremail, String pwd) async {
    Database db = await this.database;
//    var result = await db.rawQuery('SELECT * FROM user WHERE email=?', ['$paremail']);
    var result = await db.rawQuery(
        'SELECT * FROM user WHERE email=? AND password=?',
        ['$paremail', '$pwd']);
    return result;
  }

  Future<List<ModelUser>> getUserAuthentication(
      String email, String pwd) async {
    var userAuthenticationMapList = await getUserAuthenticationMapList(
        email, pwd); // first Get 'Map List' from database
    int count = userAuthenticationMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelUser> userList =
        List<ModelUser>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      userList.add(ModelUser.fromMapObject(userAuthenticationMapList[i]));
    }

    int lnght = userList.length;
    String lenght = lnght.toString();
    for (int i = 0; i <= userList.length - 1; i++) {
      debugPrint(lenght);
    }
    return userList; // finally return our Users list
  }

  Future<List<Map<String, dynamic>>> getUserMapByEmail(String email) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM user where email=?', ['$email']);
    return result;
  }

  Future<ModelUser> getUserByEmail(String email) async {
    var userMap = await getUserMapByEmail(email);
    if (userMap != null && userMap.isNotEmpty) {
      ModelUser user = ModelUser.fromMapObject(userMap[0]);
      return user;
    }
    return null;
  }

  Future<int> insertUser(ModelUser user) async {
    Database db = await this.database;
    var result = await db.insert('user', user.toMap());
    if (result != 0) {
      debugPrint('User created in local DB');
    }
    else
      debugPrint('Failed to create user in local DB');
    return result;
  }

  Future<int> updateUser(
    ModelUser user,
  ) async {
    var db = await this.database;
    var result = await db.update('user', user.toMap(),
        where: 'userId = ?', whereArgs: [user.userId]);
    return result;
  }

  Future<int> deleteUser(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM user WHERE userId = $id');
    return result;
  }

  Future<int> getUserCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from user');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //-----------------------------------------------------------------Setting Functions--------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> getSettingMapList(int userid) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM setting2 WHERE userId=?', ['$userid']);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<ModelSetting> getSettingList(int userId) async {
    var settingMapList =
        await getSettingMapList(userId); // first Get 'Map List' from database
    int count = settingMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelSetting> settingList =
        List<ModelSetting>(); //third create empty List
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      settingList.add(ModelSetting.fromMapObject(settingMapList[i]));
    }
    return settingList.isNotEmpty? settingList.elementAt(0):null; // finally return our Users list
  }

  Future<int> insertSetting(ModelSetting setting) async {
    Database db = await this.database;
    var result = await db.insert('setting2', setting.toMap());
    return result;
  }

  Future<int> updateSetting(ModelSetting setting) async {
    var db = await this.database;
    var result = await db.update('setting2', setting.toMap(),
        where: 'settingId = ?', whereArgs: [setting.settingId]);
    return result;
  }

  Future<int> deleteSetting(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM setting2 WHERE settingId = $id');
    return result;
  }

  Future<int> getSettingCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from setting2');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

//--------------------------------------------Riba Functions---------------------------------------------
  Future<List<Map<String, dynamic>>> getRibaMapList(int userid, String startDate, String endDate) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM riba WHERE userId=? and date BETWEEN "$startDate" AND "$endDate"', ['$userid']);
    return result;
  }

  Future<List<ModelRiba>> getRibaList(int userid, String startDate, String endDate) async {
    var ribaMapList =
        await getRibaMapList(userid, startDate, endDate); // first Get 'Map List' from database
    int count = ribaMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelRiba> ribaList =
        List<ModelRiba>(); //third create empty List of riba
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      ribaList.add(ModelRiba.fromMapObject(ribaMapList[i]));
    }
    return ribaList; // finally return our Users list
  }

  Future<List<Map<String, dynamic>>> getRibaMapListReceived(int userid) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM riba WHERE amount>0 AND userId=?', ['$userid']);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelRiba>> getRibaListReceived(int userid) async {
    var ribaMapList = await getRibaMapListReceived(
        userid); // first Get 'Map List' from database
    int count = ribaMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelRiba> ribaList =
        List<ModelRiba>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      ribaList.add(ModelRiba.fromMapObject(ribaMapList[i]));
    }
    return ribaList; // finally return our Users list
  }

  Future<List<Map<String, dynamic>>> getRibaMapListPaid(int userid) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM riba WHERE amount<0 AND userId=?', ['$userid']);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelRiba>> getRibaListPaid(int userid) async {
    var ribaMapList =
        await getRibaMapListPaid(userid); // first Get 'Map List' from database
    int count = ribaMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelRiba> ribaList =
        List<ModelRiba>(); //third create empty List of riba
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      ribaList.add(ModelRiba.fromMapObject(ribaMapList[i]));
    }
    return ribaList; // finally return our Users list
  }

  Future<int> insertRiba(ModelRiba riba) async {
    Database db = await this.database;
    var result = await db.insert('riba', riba.toMap());
    return result;
  }

  Future<int> updateRiba(ModelRiba riba) async {
    var db = await this.database;
    var result = await db.update('riba', riba.toMap(),
        where: 'ribaId = ?', whereArgs: [riba.ribaId]);
    return result;
  }

  Future<int> deleteRiba(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM riba WHERE ribaId = $id');
    return result;
  }

  Future<int> getRibaCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from riba');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //--------------------------------Functions for Loan--------------------------------------------
  Future<List<Map<String, dynamic>>> getLoanMapList(
      String table, String type, int userid) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $table WHERE type=? AND userId=?', ['$type', '$userid']);
    return result;
  }

  Future<List<Map<String, dynamic>>> getTotalLoanMapList(int userid) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM loan WHERE userId=?', ['$userid']);
    return result;
  }

  Future<List<ModelLoan>> getTotalLoanList(int userId) async {
    var loanMapList =
        await getTotalLoanMapList(userId); // first Get 'Map List' from database
    int count = loanMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelLoan> loanList =
        List<ModelLoan>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      loanList.add(ModelLoan.fromMapObject(loanMapList[i]));
    }
    return loanList; // finally return our Users list
  }

  Future<List<ModelLoan>> getLoanList(
      String table, String type, int userId) async {
    var loanMapList = await getLoanMapList(
        table, type, userId); // first Get 'Map List' from database
    int count = loanMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelLoan> loanList =
        List<ModelLoan>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      loanList.add(ModelLoan.fromMapObject(loanMapList[i]));
    }
    return loanList; // finally return our Users list
  }

  Future<int> updateLoan(ModelLoan loan) async {
    var db = await this.database;
    var result = await db.update('loan', loan.toMap(),
        where: 'loanid = ?', whereArgs: [loan.loanid]);
    return result;
  }

  Future<int> insertLoan(ModelLoan loan) async {
    Database db = await this.database;
    var result = await db.insert('loan', loan.toMap());
    return result;
  }

  Future<int> deleteLoan(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM loan WHERE loanid = $id');
    return result;
  }

  Future<int> getLoanCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from loan');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

//------------------------------------------zakat functions----------------------------------------------------

  Future<List<Map<String, dynamic>>> getCommonMapListZakat(String table,
      String type, String startDate, String endDate, int userid) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM "$table" WHERE date BETWEEN "$startDate" AND "$endDate" AND userID=? AND type=?',
        ['$userid', '$type']);
    return result;
  }

  Future<List<ModelCash>> getCashListZakat(String table, String type,
      String startDate, String endDate, int userid) async {
    var metalMapList = await getCommonMapListZakat(table, type, startDate,
        endDate, userid); // first Get 'Map List' from database
    int count = metalMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelCash> metalList =
        List<ModelCash>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      metalList.add(ModelCash.fromMapObject(metalMapList[i]));
    }
    return metalList; // finally return our Users list
  }

  Future<List<ModelMetal>> getMetalListZakat(String table, String type,
      String startDate, String endDate, int userid) async {
    var metalMapList = await getMapList(userid, table, type, startDate,
        endDate); // first Get 'Map List' from database
    int count = metalMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelMetal> metalList =
        List<ModelMetal>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      metalList.add(ModelMetal.fromMapObject(metalMapList[i]));
    }
    return metalList; // finally return our Users list
  }

  Future<List<Map<String, dynamic>>> getRibaMapListZakat(int userid) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM riba WHERE userId=?', ['$userid']);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelRiba>> getRibaListZakat(int userid) async {
    var ribaMapList =
        await getRibaMapListZakat(userid); // first Get 'Map List' from database
    int count = ribaMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelRiba> ribaList =
        List<ModelRiba>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      ribaList.add(ModelRiba.fromMapObject(ribaMapList[i]));
    }
    return ribaList; // finally return our Users list
  }

  Future<List<ModelLoan>> getLoanListZakat(String table, String type,
      String startDate, String endDate, int userid) async {
    var loanMapList = await getCommonMapListZakat(table, type, startDate,
        endDate, userid); // first Get 'Map List' from database
    int count = loanMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelLoan> loanList =
        List<ModelLoan>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      loanList.add(ModelLoan.fromMapObject(loanMapList[i]));
    }
    return loanList; // finally return our Users list
  }

  //---------------------------- All Functions for Zakat Paid are implemented below-----------------------------------

  Future<List<Map<String, dynamic>>> getZakatPaidMapList(int userid) async {
    Database db = await this.database;
    var result = await db
        .rawQuery('SELECT * FROM zakatPayments WHERE  userId=?', ['$userid']);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelZakatPaid>> getZakatPaidList(int userid) async {
    var zakatPaidMapList =
        await getZakatPaidMapList(userid); // first Get 'Map List' from database
    int count = zakatPaidMapList
        .length; // second Count the number of map entries fetched from  db table
    List<ModelZakatPaid> zakatList =
        List<ModelZakatPaid>(); //third create empty List of Gold
    // For loop to copy all the 'Map list object' into our UsersList'
    for (int i = 0; i < count; i++) {
      zakatList.add(ModelZakatPaid.fromMapObject(zakatPaidMapList[i]));
    }
    return zakatList; // finally return our Users list
  }

  Future<int> insertZakatPaid(ModelZakatPaid zakat) async {
    Database db = await this.database;
    var result = await db.insert('zakatPayments', zakat.toMap());
    return result;
  }

  Future<int> updateZakatPaid(ModelZakatPaid zakat) async {
    var db = await this.database;
    var result = await db.update('zakatPayments', zakat.toMap(),
        where: 'zakatPaymentId = ?', whereArgs: [zakat.zakatPaymentId]);
    return result;
  }

  Future<int> deleteZakatPaid(int id) async {
    var db = await this.database;
    int result = await db
        .rawDelete('DELETE FROM zakatPayments WHERE zakatPaymentId = $id');
    return result;
  }

  Future<int> getZakatPaidCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from zakatPayments');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
} // End of Class
