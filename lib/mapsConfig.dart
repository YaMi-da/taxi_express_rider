import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_express_rider/Models/Users.dart';

String mapkey = "AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg";

User firebaseUser;

Users usersCurrentInfo;

int driverRequestTimeOut = 40;

String statusRide = "";

String rideStatus = "Your Driver is on the way";

String carDetailsDriver = "";

String driverName = "";

String driverPhone = "";

double starCounter = 0.0;

String title = "";

String carRideType = "";

String serverToken = "key=AAAAuNpojEs:APA91bGHw7uTHWrHu-QMxLFFJO0cWVJ8e-D1Xcy_7lrK"
    "-PPnMCBJ5jIN5ptycRioKNa5NN5M6kfJXX79aBEjYSNZumDZX3HjWLbexuBmBLDR2XIwoSWdwYe7WzSGdRvm0wgQMaufgw09";