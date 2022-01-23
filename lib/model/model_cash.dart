class ModelCash {
//_name means that it is private for application
  int _cashId; //cash in Hand ID
  String _title;
  double _amount;
  String _date;
  String _note;
  String _type;
  int _userId;

  ModelCash.withId(this._cashId, this._title, this._amount, this._date,
      this._note, this._type, this._userId);

  ModelCash(this._title, this._amount, this._date, this._note, this._type,
      this._userId);

  int get userId => _userId;
  String get type => _type;
  String get note => _note;
  String get date => _date;
  double get amount => _amount;
  String get title => _title;
  int get cashId => _cashId;

  set userId(int value) {
    _userId = value;
  }

  set type(String value) {
    _type = value;
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

  set title(String value) {
    _title = value;
  }

  set cashId(int value) {
    _cashId = value;
  }

  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (cashId != null) {
      map['cashId'] = _cashId;
    }
    //then insert _name into map object with the key of name and so on
    map['title'] = _title;
    map['amount'] = _amount;
    map['date'] = _date;
    map['note'] = _note;
    map['type'] = _type;
    map['userId'] = _userId;

    return map;
  }

  ModelCash.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this._cashId = map['cashId'];
    this._title = map['title'];
    this._amount = map['amount'];
    this._date = map['date'];
    this._note = map['note'];
    this._type = map['type'];
    this._userId = map['userId'];
  }
}
