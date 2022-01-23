import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sadaqah_manager/home_page.dart';
import 'package:sadaqah_manager/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:sadaqah_manager/locale/app_localization.dart';
//import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart' as ios;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp(prefs)),
  );
}

class MyApp extends StatelessWidget {
  SharedPreferences prefs;

  MyApp(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  @override
  Widget build(BuildContext context) {
    var status = prefs.getBool('isLoggedIn') ?? false;
    var email = prefs.getString('email') ?? 'try';
    var userId = prefs.getInt('userId') ?? 0;
    debugPrint('status: $status');
    debugPrint('email: $email');
    debugPrint('userId: $userId');
    //context.locale = Locale("en","US");
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        theme: new ThemeData(
          primaryColor: Colors.red,
          appBarTheme: AppBarTheme(
            color: Colors.red,
          ),
        ),
        home: status == false
            ? LoginScreen(true)
            : HomePage(email, int.parse('$userId'), false));
  }
}
