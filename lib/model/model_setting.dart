class ModelSetting {
//_name means that it is private for application
  int _settingId;
  String country;
  String currency;
  double nisab;
  String startDate;
  String endDate;
  double goldRate18C;
  double goldRate20C;
  double goldRate22C;
  double goldRate24C;
  double silverRate18C;
  double silverRate20C;
  double silverRate22C;
  double silverRate24C;
  int userId;

  ModelSetting.withId(
      this._settingId,
      this.country,
      this.currency,
      this.nisab,
      this.startDate,
      this.endDate,
      this.goldRate18C,
      this.goldRate20C,
      this.goldRate22C,
      this.goldRate24C,
      this.silverRate18C,
      this.silverRate20C,
      this.silverRate22C,
      this.silverRate24C,
      this.userId);

  ModelSetting(
      {this.country = '',
      this.currency,
      this.nisab,
      this.startDate,
      this.endDate,
      this.goldRate18C,
      this.goldRate20C,
      this.goldRate22C,
      this.goldRate24C,
      this.silverRate18C,
      this.silverRate20C,
      this.silverRate22C,
      this.silverRate24C,
      this.userId});

  int get settingId => _settingId;

  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (settingId != null) {
      map['settingId'] = _settingId;
    }
    //then insert _name into map object with the key of name and so on
    map['country'] = country;
    map['currency'] = currency;
    map['nisab'] = nisab;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['goldRate18C'] = goldRate18C;
    map['goldRate20C'] = goldRate20C;
    map['goldRate22C'] = goldRate22C;
    map['goldRate24C'] = goldRate24C;
    map['silverRate18C'] = silverRate18C;
    map['silverRate20C'] = silverRate20C;
    map['silverRate22C'] = silverRate22C;
    map['silverRate24C'] = silverRate24C;
    map['userId'] = userId;
    return map;
  }

  ModelSetting.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this._settingId = map['settingId'];
    this.country = map['country'];
    this.currency = map['currency'];
    this.nisab = map['nisab'];
    this.startDate = map['startDate'];
    this.endDate = map['endDate'];
    this.goldRate18C = map['goldRate18C'];
    this.goldRate20C = map['goldRate20C'];
    this.goldRate22C = map['goldRate22C'];
    this.goldRate24C = map['goldRate24C'];
    this.silverRate18C = map['silverRate18C'];
    this.silverRate20C = map['silverRate20C'];
    this.silverRate22C = map['silverRate22C'];
    this.silverRate24C = map['silverRate24C'];
    this.userId = map['userId'];
  }
}
