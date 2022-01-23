class ModelZakatPaid {
  int _zakatPaymentId;
  String _title;
  String _startDate;
  String _endDate;
  String _paymentDate;
  double _amount;
  String _note;
  int _userId;

  ModelZakatPaid.withId(this._zakatPaymentId, this._title, this._startDate,
      this._endDate, this._paymentDate, this._amount, this._note, this._userId);

  ModelZakatPaid(this._title, this._startDate, this._endDate, this._paymentDate,
      this._amount, this._note, this._userId);

  int get zakatPaymentId => _zakatPaymentId;
  String get title => _title;
  String get startDate => _startDate;
  String get endDate => _endDate;
  String get paymentDate => _paymentDate;
  double get amount => _amount;
  String get note => _note;
  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  set paymentDate(String value) {
    _paymentDate = value;
  }

  set amount(double value) {
    _amount = value;
  }

  set endDate(String date) {
    _endDate = date;
  }

  set startDate(String date) {
    _startDate = date;
  }

  set title(String title) {
    _title = title;
  }

  set note(String note) {
    _note = note;
  }

  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (zakatPaymentId != null) {
      map['zakatPaymentId'] = _zakatPaymentId;
    }
    //then insert _name into map object with the key of name and so on
    map['title'] = _title;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    map['amount'] = _amount;
    map['paymentDate'] = _paymentDate;
    map['note'] = _note;
    map['userId'] = _userId;
    return map;
  }

  ModelZakatPaid.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this._zakatPaymentId = map['zakatPaymentId'];
    this._title = map['title'];
    this._startDate = map['startDate'];
    this._endDate = map['endDate'];
    this._amount = map['amount'];
    this._paymentDate = map['paymentDate'];
    this._note = map['note'];
    this._userId = map['userId'];
  }
}
