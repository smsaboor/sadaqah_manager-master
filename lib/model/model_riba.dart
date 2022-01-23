class ModelRiba {
//_name means that it is private for application
  int _ribaId; //cash in Hand ID
  String _bankName;
  double _amount;
  String _date;
  String _note;
  int _userId;

  ModelRiba.withId(this._ribaId, this._bankName, this._amount, this._date,
      this._note, this._userId);

  ModelRiba(this._bankName, this._amount, this._date, this._note, this._userId);

  int get userId => _userId;
  String get note => _note;
  String get date => _date;
  double get amount => _amount;
  String get bankName => _bankName;
  int get ribaId => _ribaId;

  set userId(int value) {
    _userId = value;
  }

  set note(String value) {
    _note = value;
  }

  set date(String value) {
    _date = value;
  }

  set amount(double value) {
    _amount = value;
  }

  set bankName(String value) {
    _bankName = value;
  }

  set ribaId(int value) {
    _ribaId = value;
  }

  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (ribaId != null) {
      map['ribaId'] = _ribaId;
    }
    //then insert _name into map object with the key of name and so on
    map['bankName'] = _bankName;
    map['amount'] = _amount;
    map['date'] = _date;
    map['note'] = _note;
    map['userId'] = _userId;

    return map;
  }

  ModelRiba.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this._ribaId = map['ribaId'];
    this._bankName = map['bankName'];
    this._amount = map['amount'];
    this._date = map['date'];
    this._note = map['note'];
    this._userId = map['userId'];
  }
}
