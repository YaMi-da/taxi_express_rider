import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:taxi_express_rider/Widgets/SearchDivider.dart';
import 'package:taxi_express_rider/mapsConfig.dart';

class RatingScreen extends StatefulWidget {

  final String driverId;

  RatingScreen({this.driverId});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 0,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[200],
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0,),
              Text(
                "Rate This Driver",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 22.0,),

              DividerWidget(),

              SizedBox(height: 16.0,),

              SmoothStarRating(
                rating: starCounter,
                borderColor: Colors.black,
                color: Color.fromRGBO(146, 27, 31, 1),
                allowHalfRating: false,
                starCount: 5,
                size: 45,
                onRated: (value) {
                  starCounter = value;

                  if(starCounter == 1){
                    setState(() {
                      title =  "Can't Get Any Worse";
                    });
                  }
                  if(starCounter == 2){
                    setState(() {
                      title = "Not So Good";
                    });
                  }
                  if(starCounter == 3){
                    setState(() {
                      title =  "Have Had Better";
                    });
                  }
                  if(starCounter == 4){
                    setState(() {
                      title =  "Good Ride";
                    });
                  }
                  if(starCounter == 5){
                    setState(() {
                      title =  "Can't Get Any Better";
                    });
                  }
                },
              ),

              SizedBox(height: 14.0,),

              Text(
                title,
                style: TextStyle(fontSize: 35.0, color: Color.fromRGBO(146, 27, 31, 1),),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.0,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  onPressed: ()async {
                    DatabaseReference driverRatingRef = FirebaseDatabase.instance.reference().child("Users").child("Drivers").child(widget
                        .driverId).child("ratings");
                    driverRatingRef.once().then((DataSnapshot snap) {
                      if(snap.value != null){
                        double oldRatings = double.parse(snap.value.toString());
                        double addRatings = oldRatings + starCounter;
                        double avgRatings = addRatings/2;
                        driverRatingRef.set(avgRatings.toString());
                      }
                      else{
                        driverRatingRef.set(starCounter.toString());
                      }
                    });

                    Navigator.pop(context);
                  },
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ) ,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.0,),
            ],
          ),
        ),
      ),
    );
  }
}
