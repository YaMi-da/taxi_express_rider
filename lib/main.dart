import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_express_rider/Data/appData.dart';
import 'package:taxi_express_rider/Screens/ProfileScreen.dart';
import 'package:taxi_express_rider/Screens/aboutScreen.dart';
import 'package:taxi_express_rider/Screens/historyScreen.dart';
import 'Screens/screens.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child
  ("Users").child("Riders");
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child
  ("Users").child("Drivers");
DatabaseReference newRequestRef = FirebaseDatabase.instance.reference().child("RideRequests");



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'TaxiExpress',
        theme: ThemeData(
          fontFamily: "JosefinSans-Medium",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null ? 'LoginScreen' : 'MainScreen',
        routes: {
          '/': (context) => LoginScreen(),
          'Forgot Password':(context) => ForgotPassword(),
          'Create New Account':(context) => CreateNewAccount(),
          'MainScreen':(context) => MainScreen(),
          'AboutScreen':(context) => AboutScreen(),
          'ProfileScreen':(context) => ProfileScreen(),
          'HistoryScreen':(context) => HistoryScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

