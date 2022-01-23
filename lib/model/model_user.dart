class ModelUser {
//_name means that it is private for application
  int _userId;
  String _name;
  String _email;
  String _password;
  String _registrationDate; // user registration date
  String _isPaid;
  int _age;
  String _paymentDate;
  String _city;
  int _pin;
  int _familyId;
  String _photoUrl;

  ModelUser.withId(
      this._userId,
      this._name,
      this._email,
      this._password,
      this._registrationDate,
      this._isPaid,
      this._age,
      this._paymentDate,
      this._city,
      this._pin,
      this._familyId,
      this._photoUrl);

  ModelUser(
      this._name,
      this._email,
      this._password,
      this._registrationDate,
      this._isPaid,
      this._age,
      this._paymentDate,
      this._city,
      this._pin,
      this._familyId,
      this._photoUrl);

  int get userId => _userId;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get registrationDate => _registrationDate;
  String get isPaid => _isPaid;
  int get age => _age;
  String get paymentDate => _paymentDate;
  String get city => _city;
  int get pin => _pin;
  int get familyId => _familyId;
  String get photoUrl => _photoUrl;

  set familyId(int value) {
    _familyId = value;
  }

  set pin(int value) {
    _pin = value;
  }

  set city(String value) {
    _city = value;
  }

  set paymentDate(String value) {
    _paymentDate = value;
  }

  set age(int value) {
    _age = value;
  }

  set isPaid(String value) {
    _isPaid = value;
  }

  set registrationDate(String value) {
    _registrationDate = value;
  }

  set password(String value) {
    _password = value;
  }

  set email(String value) {
    _email = value;
  }

  set photoUrl(String value) {
    _photoUrl = value;
  }

  set name(String value) {
    _name = value;
  }

  set userId(int value) {
    userId = value;
  }

  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (userId != null) {
      map['userId'] = _userId;
    }
    //then insert _name into map object with the key of name and so on
    map['name'] = _name;
    map['email'] = _email;
    map['password'] = _password;
    map['age'] = _age;
    map['registrationDate'] = _registrationDate;
    map['isPaid'] = _isPaid;
    map['paymentDate'] = _paymentDate;
    map['city'] = _city;
    map['pin'] = _pin;
    map['familyId'] = _familyId;
    map['photoUrl'] = _photoUrl;

    return map;
  }

  ModelUser.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this._userId = map['userId'];
    this._name = map['name'];
    this._email = map['email'];
    this._password = map['password'];
    this._age = map['age'];
    this._registrationDate = map['registrationDate'];
    this._isPaid = map['isPaid'];
    this._paymentDate = map['paymentDate'];
    this._city = map['city'];
    this._pin = map['pin'];
    this._familyId = map['familyId'];
    this._photoUrl = map['photoUrl'];
  }
}
