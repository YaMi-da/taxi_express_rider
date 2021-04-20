import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      brightness: Brightness.dark,
      toolbarHeight: 0,
      backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            height: 320,
            child: Center(
              child: Image.asset('images\\normal_car.png'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 24, right: 24),
            child: Column(
              children: [
                Text(
                  "Taxi Express",
                  style: TextStyle(
                    fontSize: 70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30,),

                Text(
                  "Need a Ride? Well, You've Come to The Right Place !",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),

          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Container(
              // ignore: deprecated_member_use
              child: RaisedButton(
                color: Color.fromRGBO(146, 27, 31, 1),
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, 'MainScreen', (route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
                      SizedBox(width: 10,),
                      Text(
                        "Back to Main Screen",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
