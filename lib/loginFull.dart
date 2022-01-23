//import 'package:flutter/material.dart';
//import 'package:sadaqah_manager/home_page.dart';
//import 'package:sadaqah_manager/model/model_user.dart';
//import 'package:sadaqah_manager/user_registration.dart';
//import 'package:sadaqah_manager/helper/database_helper.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//
//
//class LoginScreen extends StatefulWidget {
//  bool logoutStatus;
//  LoginScreen(this.logoutStatus);
//  @override
//  State<StatefulWidget> createState() {
//    return LoginScreenState(this.logoutStatus);
//  }
//}
//class LoginScreenState extends State<LoginScreen> {
//
//  bool logoutStatus;
//  LoginScreenState(this.logoutStatus);
//  SharedPreferences prefs;
//  bool checkValue = false;
//  UserDetails detailsUserSave;
//  int countS=0,countU=0;
//  String email='';
//  int userid=0;
////Firebase Implementation----------------------------------------------------------------
//  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//  final GoogleSignIn _googlSignIn = new GoogleSignIn();
//
//  Future<FirebaseUser> _signIn() async {
//    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
//    final GoogleSignInAuthentication googleAuth =await googleUser.authentication;
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//    FirebaseUser userDetails = await _firebaseAuth.signInWithCredential(credential);
//    ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);
//    List<ProviderDetails> providerData = new List<ProviderDetails>();
//    providerData.add(providerInfo);
//    UserDetails details = new UserDetails(
//      userDetails.providerId,
//      userDetails.displayName,
//      userDetails.photoUrl,
//      userDetails.email,
//      providerData,
//    );
//    detailsUserSave=details;
//    Navigator.push(
//      context,
//      new MaterialPageRoute(
//        builder: (context) => new HomePage.googleLogin(1,true,userid,ModelUsers(
//            '', '', '', '', 00, '', '', 000000, 1),detailsUser: details),
////        builder: (context) => new ProfileScreen(detailsUser: details),
//      ),
//    );
//    return userDetails;
//  }
//
//  ModelUsers user;
//  DataHelper databaseHelper = DataHelper();
//  List<ModelUsers> userList;
//  int count = 0;
//
//  final TextEditingController _controller1 = new TextEditingController();
//  final TextEditingController _controller2 = new TextEditingController();
//
//
//
//
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (userList == null) {
//      userList = List<ModelUsers>();
//    }
//
////    ListView getRibaReceivedList() {
//    return Scaffold(
//      body: _body(),
//    );
//  }
//
//  Widget _body(){
//    return new ListView(
//      children: <Widget>[
//        Stack(
//          children: <Widget>[
//            ClipPath(
//              child: Container(
//                child: Column(),
//                width: double.infinity,
//                height: 300,
//                decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                        colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
//              ),
//            ),
//            ClipPath(
//              child: Container(
//                child: Column(),
//                width: double.infinity,
//                height: 300,
//                decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                        colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
//              ),
//            ),
//            ClipPath(
//              child: Container(
//                child: Column(
//                  children: <Widget>[
//                    SizedBox(
//                      height: 40,
//                    ),
//                    Icon(
//                      Icons.account_balance,
//                      color: Colors.white,
//                      size: 60,
//                    ),
//                    SizedBox(
//                      height: 20,
//                    ),
//                    Text(
//                      "Sadaqaah Manager",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.w700,
//                          fontSize: 30),
//                    ),
//                  ],
//                ),
//                width: double.infinity,
//                height: 300,
//                decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                        colors: [Color(0xffff3a5a), Color(0xfffe494d)])),
//              ),
//            ),
//          ],
//        ),
//        SizedBox(
//          height: 30,
//        ),
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 32),
//          child: Material(
//            elevation: 2.0,
//            borderRadius: BorderRadius.all(Radius.circular(30)),
//            child: TextField(
//              controller: _controller1,
//              onChanged: (String value) {},
//              cursorColor: Colors.deepOrange,
//              decoration: InputDecoration(
//                  hintText: "Email",
//                  prefixIcon: Material(
//                    elevation: 0,
//                    borderRadius: BorderRadius.all(Radius.circular(30)),
//                    child: Icon(
//                      Icons.email,
//                      color: Colors.red,
//                    ),
//                  ),
//                  border: InputBorder.none,
//                  contentPadding:
//                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
//            ),
//          ),
//        ),
//        SizedBox(
//          height: 20,
//        ),
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 32),
//          child: Material(
//            elevation: 2.0,
//            borderRadius: BorderRadius.all(Radius.circular(30)),
//            child: TextField(
//              controller: _controller2,
//              obscureText: true,
//              onChanged: (String value) {},
//              cursorColor: Colors.deepOrange,
//              decoration: InputDecoration(
//                  hintText: "Password",
//                  prefixIcon: Material(
//                    elevation: 0,
//                    borderRadius: BorderRadius.all(Radius.circular(30)),
//                    child: Icon(
//                      Icons.lock,
//                      color: Colors.red,
//                    ),
//                  ),
//                  border: InputBorder.none,
//                  contentPadding:
//                  EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
//            ),
//          ),
//        ),
//        SizedBox(
//          height: 25,
//        ),
//        Padding(
//            padding: EdgeInsets.symmetric(horizontal: 32),
//            child: Container(
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.all(Radius.circular(100)),
//                  color: Color(0xffff3a5a)),
//              child: FlatButton(
//                child: Text(
//                  "Login",
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontWeight: FontWeight.w700,
//                      fontSize: 18),
//                ),
//                onPressed: () {
//                  debugPrint('Login button pressed');
//                  getUserAuthentication();
//                },
//              ),
//            )),
//        SizedBox(height: 5,),
//        Padding(
//            padding: EdgeInsets.symmetric(horizontal: 32),
//            child: Container(
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.all(Radius.circular(100)),
//                  color: Color(0xffff5d5f)),
//              child: FlatButton.icon(
//                  icon: Icon(FontAwesomeIcons.google, color: Colors.white,),
//                  label: Text("Sign In", style: TextStyle(color: Colors.white),),
//                  onPressed: () async{
//                    _signIn()
//                        .then((FirebaseUser user) {
//                      print(user);
//                    })
//                        .catchError((e) => print('$e'));
//
//                  }
//              ),
//            )),
//        SizedBox(height: 10,),
//        Center(
//          child: Text("FORGOT PASSWORD ?", style: TextStyle(
//              color: Colors.red, fontSize: 12, fontWeight: FontWeight.w700),),
//        ),
//        SizedBox(height: 5,),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text("Don't have an Account ? ", style: TextStyle(
//                color: Colors.black,
//                fontSize: 12,
//                fontWeight: FontWeight.normal),),
//            GestureDetector(
//              onTap: () {
//                navigateToRegistration(ModelUsers(
//                    '',
//                    '',
//                    '',
//                    '',
//                    70,
//                    '',
//                    '',
//                    262701,
//                    1), 'User Registration');
//              },
//              child: Text("Sign Up ", style: TextStyle(color: Colors.red,
//                  fontWeight: FontWeight.w500,
//                  fontSize: 12,
//                  decoration: TextDecoration.underline)),
//            )
//          ],
//        )
//      ],
//    );
//  }
//
//
//
//  void navigateToRegistration(ModelUsers user, String appBarTitle) async {
//    await Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return UserRegistration(user, appBarTitle);
//    }));
//  }
//
//  void getUserAuthentication() async {
//    prefs = await SharedPreferences.getInstance();
//    String email; String password; int familtId;
//    setState(() {
//      email = _controller1.text.toString();
//      password = _controller2.text.toString();
//    });
//    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
//    dbFuture.then((database) {
//      Future<List<ModelUsers>> userListFuture = databaseHelper
//          .getUserAuthentication(email, password);
//      userListFuture.then((userList) {
//        setState(() {
//          this.userList = userList;
//          this.count = userList.length;
//          if(count!=0)
//          {
//            this.userid=userList[0].userId;
//            familtId=userList[0].familyId;
//          }
//        });
//
//        if(count!=0) {
//          setState(() {
//            prefs?.setBool("isLoggedIn", true);
//            prefs?.setString("email", email);
//            prefs?.setInt("userId", this.userid);
//            navigateToHome(email,this.userid,familtId,true);
//          });
//        }
//      });
//    });
//  }
//  void navigateToHome(String email, int userid, int familyid, bool loginstatus) async {
//    bool result =
//    await Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return HomePage(0,email,userid,familyid,loginstatus);
//    }));
//
//  }
//}
//
//class UserDetails {
//  final String providerDetails;
//  final String userName;
//  final String photoUrl;
//  final String userEmail;
//  final List<ProviderDetails> providerData;
//
//  UserDetails(this.providerDetails,this.userName, this.photoUrl,this.userEmail, this.providerData);
//}
//
//
//class ProviderDetails {
//  ProviderDetails(this.providerDetails);
//  final String providerDetails;
//}