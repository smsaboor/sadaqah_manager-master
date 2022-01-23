import 'package:flutter/material.dart';
import 'package:sadaqah_manager/model/model_user.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';


class UserRegistration extends StatefulWidget {
  final appBarTitle;
  final ModelUser user;

  UserRegistration(this.user, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return UserRegistrationState(this.user,this.appBarTitle);
  }
}
class UserRegistrationState extends State<UserRegistration> {
  final appBarTitle;
  ModelUser user;
  int result;
  UserRegistrationState(this.user, this.appBarTitle);
  DataHelper helper = DataHelper();



  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();
  final TextEditingController _controller3 = new TextEditingController();
  final TextEditingController _controller4 = new TextEditingController();
  final TextEditingController _controller5 = new TextEditingController();
  final TextEditingController _controller6 = new TextEditingController();
  final TextEditingController _controller7 = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(user.userId!=null) {
      _controller1.text = user.email;
      _controller2.text = user.password.toString();
      _controller3.text = user.age.toString();
      _controller4.text = user.isPaid;
      _controller5.text = user.paymentDate;
      _controller6.text = user.city;
      _controller7.text = user.pin.toString();

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff3a5a),
        title: new Text(appBarTitle, style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22)),
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            }
        ),),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
                ),
              ),
              ClipPath(
                child: Container(
                  child: Column(),
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                ),
              ),
              ClipPath(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextField(
                            controller: _controller1,
                            onChanged: (String value){},
                            cursorColor: Colors.deepOrange,
                            decoration: InputDecoration(
                                hintText: "Email",
                                suffixText:"email",
                                suffixStyle: const TextStyle(color: Colors.red,fontSize: 14.0),
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.red,
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextField(
                            controller: _controller2,
                            obscureText: true,
                            onChanged: (String value){},
                            cursorColor: Colors.deepOrange,
                            decoration: InputDecoration(
                                hintText: "Password",
                                suffixText:"PWD",
                                suffixStyle: const TextStyle(color: Colors.red,fontSize: 14.0),
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.red,
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffff3a5a), Color(0xfffe494d)])),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                controller: _controller3,
                onChanged: (String value){},
                cursorColor: Colors.deepOrange,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Age",
                    suffixText:"Age",

                    suffixStyle: const TextStyle(color: Colors.red,fontSize: 14.0),
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.red,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                controller: _controller6,
                onChanged: (String value){},
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "City",
                    suffixText:"City",
                    suffixStyle: const TextStyle(color: Colors.red,fontSize: 14.0),
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.location_city,
                        color: Colors.red,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextField(
                controller: _controller7,
                onChanged: (String value){},
                cursorColor: Colors.deepOrange,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Pin",
                    suffixText:"PIN",
                    suffixStyle: const TextStyle(color: Colors.red,fontSize: 14.0),
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.person_pin_circle,
                        color: Colors.red,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
              ),
            ),
          ),
          SizedBox(
            height: 110,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Color(0xffff3a5a)),
                child: FlatButton(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    setState(() {
                      _save();
                      moveToLastScreen();
                    });
                  },
                ),
              )),

        ],
      ),
    );
  }
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
  void _save() async {
    if(user.userId==null) {
      this.user.email = _controller1.text.toString();
      this.user.password = _controller2.text.toString();
      this.user.registrationDate = '12.12.2019';
      String age = _controller3.text.toString();
      this.user.age = int.parse('$age');
      this.user.isPaid = 'yes';
      this.user.paymentDate = '12.12.2019';
      this.user.city = _controller6.text.toString();
      String pin = _controller7.text.toString();
      this.user.pin = int.parse('$pin');
      this.user.familyId = 1;
    }
    int result;
    if (user.userId != null) {
      result = await helper.updateUser(user);
    } else { // Case 2: Insert Operation
      result = await helper.insertUser(user);
      helper.getUserList();
    }
    if (result != 0) { // Success
      _showAlertDialog('Congratulation !!', 'User Successfully Registered.');
      _resetTextField();
    } else { // Failure
      _showAlertDialog('Sorry !', 'User Registration Failed.');
    }
  }
  void _showAlertDialog(String title, String message) {
    showDialog(context: context,
        builder: (_) => AlertDialog(
          title: Text(title, style: TextStyle( fontSize: 20.0, color: Colors.green, fontWeight: FontWeight.bold,),
              textAlign:TextAlign.center),
          content: Text(message,style: TextStyle( fontSize: 18.0, color: Colors.red, fontWeight: FontWeight.bold,),textAlign:TextAlign.center),
        ));

  }
  void _resetTextField(){
    _controller1.text='';_controller2.text='';_controller3.text='';_controller4.text='';
    _controller5.text='';_controller6.text='';_controller7.text='';
  }

}