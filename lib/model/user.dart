class UserModel {
//_name means that it is private for application
  int _id;
  String _name;
  String _email;
  String _mobile;
  String _password;
  String _date;
//if we want to make variable optional then put it within [] eg: [this.description]
  // below is a unnamed constructor in flutter there is only one unnamed constructor allowed
  UserModel(this._name, this._email, this._mobile, this._password, this._date);
//below is named constructor
  UserModel.withId(this._id, this._name, this._email, this._mobile,
      this._password, this._date);

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get mobile => _mobile;
  String get password => _password;
  String get date => _date;

  //below are setters ,here we do not create setter for id becouse it id  generate automatically
  //setters are with validations before saving it so we give more validation logics for our app
  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set email(String newEmail) {
    if (newEmail.length <= 255) {
      this._email = newEmail;
    }
  }

  set mobile(String newMobile) {
    if (newMobile.length <= 255) {
      this._mobile = newMobile;
    }
  }

  set password(String newPassword) {
    if (newPassword.length <= 255) {
      this._password = newPassword;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // function to Convert a UserModel object into a Map object
  //toMap() is a function is used to insert or any operation
  //String is used becouse map object is always string but normal object like id,name is of any type so dynamic keyword is used to represent both/all at runtime
  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    //then insert _name into map object with the key of name and so on
    map['name'] = _name;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['password'] = _password;
    map['date'] = _date;

    return map;
  }

  // function help to Extract a UserModel object from a Map object
  //it looks like reverse of above function
  //below line we create a named cunstructor that will take map as a parameter and simply crete instance of a UserModel object
  UserModel.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this._id = map['id'];
    this._name = map['name'];
    this._email = map['email'];
    this._mobile = map['mobile'];
    this._password = map['password'];
    this._date = map['date'];
  }
}
