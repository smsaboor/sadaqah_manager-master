import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadaqah_manager/home_page.dart';
import 'package:sadaqah_manager/model/model_setting.dart';
import 'package:sadaqah_manager/model/model_user.dart';
import 'package:sadaqah_manager/user_registration.dart';
import 'package:sadaqah_manager/helper/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sadaqah_manager/util/country_pickers.dart';

class LoginScreen extends StatefulWidget {
  bool logoutStatus;
  LoginScreen(this.logoutStatus);
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState(this.logoutStatus);
  }
}

class LoginScreenState extends State<LoginScreen> {
  bool logoutStatus;
  LoginScreenState(this.logoutStatus);
  SharedPreferences prefs;
  bool checkValue = false;
  int countS = 0, countU = 0;
  String email = '';
  int userid = 0;

//Firebase Implementation----------------------------------------------------------------
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();

  Future<User> _signIn() async {
    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    User userDetails = userCredential.user;
    ProviderDetails providerInfo = new ProviderDetails(userDetails.uid);
    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(providerInfo);
    UserDetails details = new UserDetails(
      userDetails.uid,
      userDetails.displayName,
      userDetails.photoURL,
      userDetails.email,
      providerData,
    );
    prefs = await SharedPreferences.getInstance();
    saveUser(details);
    return userDetails;
  }

  ModelUser user;
  DataHelper databaseHelper = DataHelper();
  int count = 0;

  final TextEditingController _controller1 = new TextEditingController();
  final TextEditingController _controller2 = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return new ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                child: Column(),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
              ),
            ),
            ClipPath(
              child: Container(
                child: Column(),
                width: double.infinity,
                height: 300,
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
                    Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Sadaqah Manager",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30),
                    ),
                  ],
                ),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xffff3a5a), Color(0xfffe494d)])),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 110,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color(0xffff5d5f)),
              child: FlatButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Sign in with your Google account",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    _signIn().then((User user) {
                      print(user);
                    }).catchError((e) => print('$e'));
                  }),
            )),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  void navigateToRegistration(ModelUser user, String appBarTitle) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UserRegistration(user, appBarTitle);
    }));
  }

  void getUserAuthentication() async {
    prefs = await SharedPreferences.getInstance();
    String email;
    String password;
    setState(() {
      email = _controller1.text.toString();
      password = _controller2.text.toString();
    });

    Future<List<ModelUser>> userListFuture =
        databaseHelper.getUserAuthentication(email, password);
    userListFuture.then((userList) {
      setState(() {
        this.count = userList.length;
        if (count != 0) {
          this.userid = userList[0].userId;
        }
      });

      if (count != 0) {
        setState(() {
          prefs?.setBool("isLoggedIn", true);
          prefs?.setString("email", email);
          prefs?.setInt("userId", this.userid);
          navigateToHome(email, this.userid, true);
        });
      }
    });
  }

  void navigateToHome(String email, int userid, bool loginstatus) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage(email, userid, loginstatus);
    }));
  }

  Future<ModelUser> saveUser(UserDetails userDetails) async {
    Future<ModelUser> userListFuture =
        databaseHelper.getUserByEmail(userDetails.userEmail);
    userListFuture.then((user) async {
      if (user != null) {
        user.name = userDetails.userName;
        user.photoUrl = userDetails.photoUrl;
        var result = await databaseHelper.updateUser(user);
        debugPrint('User update status: $result');
        prefs?.setInt("userId", user.userId);
      } else {
        ModelUser newUser = ModelUser(
            userDetails.userName,
            userDetails.userEmail,
            null,
            DateTime.now().toString(),
            'false',
            0,
            '',
            '',
            0,
            0,
            userDetails.photoUrl);
        var result = await databaseHelper.insertUser(newUser);
        debugPrint('User creation status: $result');
        Future<ModelUser> userFuture =
            databaseHelper.getUserByEmail(userDetails.userEmail);
        userFuture.then((user) async {
          prefs?.setInt("userId", user.userId);
          ModelSetting setting = ModelSetting();
          setting.userId = user.userId;
          setting.country =
              CountryPickerUtils.getCountryByIsoCode('IN').isoCode;
          setting.currency =
              CountryPickerUtils.getCountryByIsoCode('IN').currencyCode;
          setting.startDate =
              '${DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(new Duration(days: 354)))}';
          setting.endDate =
              '${DateFormat("yyyy-MM-dd").format(DateTime.now())}';
          await databaseHelper.insertSetting(setting);
        });
      }
      prefs?.setBool("isLoggedIn", true);
      prefs?.setString("email", userDetails.userEmail);
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) =>
              new HomePage(userDetails.userEmail, userid, false),
//        builder: (context) => new ProfileScreen(detailsUser: details),
        ),
      );
    });
  }
}

class UserDetails {
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.providerDetails, this.userName, this.photoUrl,
      this.userEmail, this.providerData);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
