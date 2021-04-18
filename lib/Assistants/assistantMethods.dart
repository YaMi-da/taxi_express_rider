import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:taxi_express_rider/Assistants/requestAssistant.dart';
import 'package:taxi_express_rider/Models/Users.dart';
import 'package:taxi_express_rider/Models/addresses.dart';
import 'package:taxi_express_rider/Data/appData.dart';
import 'package:taxi_express_rider/Models/directionDetails.dart';
import 'package:taxi_express_rider/Models/history.dart';
import 'package:taxi_express_rider/mapsConfig.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class AssistantMethods{
  static Future<dynamic> searchCoordinateAdress(Position position, context)
  async{
    var placeAdress;
    var st0, st1, st2, st3, st4, st6, st5;
    String url = "https://maps.googleapis"
        ".com/maps/api/geocode/json?latlng=${position.latitude},${position
        .longitude}&key=AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg";

    var response = await RequestAssistant.getRequest(url);

    if(response != "failed"){
      //placeAdress = response["results"][0]["formatted_address"];
      st0 = response["results"][0]["address_components"][0]["long_name"];
      st1 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][2]["long_name"];
      st4 = response["results"][0]["address_components"][3]["long_name"];
      st6 = response["results"][0]["address_components"][4]["long_name"];


      placeAdress = st0 + ", " + st1 + ", " + st4 + ", " + st6 +  ", " + st3;

      Address userPickUpAdress = new Address();
      userPickUpAdress.placeName = placeAdress;
      userPickUpAdress.latitude = position.latitude;
      userPickUpAdress.longitude = position.longitude;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress
        (userPickUpAdress);
    }
    return placeAdress;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async{
    String directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}"
        "&destination=${finalPosition.latitude},${finalPosition.longitude}&key=AIzaSyAuBdVRNHIXcARUTjZEp68kyNrFRSk1Xwg";

    var res = await RequestAssistant.getRequest(directionURL);

    if(res == "failed"){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }
  static int calculateFares(DirectionDetails directionDetails){

    double timeTravelledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTravelledFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTravelledFare + distanceTravelledFare;

    //double totalLocalAmount = totalFareAmount * 160;
    return totalFareAmount.truncate();

  }

  static void getCurrentOnlineUserInfo() async{
    firebaseUser = FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("Users").child("Riders").child(userId);
    
    reference.once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null){
        usersCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }
  
  static double createRandomNumber(int num){
    var random = Random();
    int randNumber = random.nextInt(num);
    return randNumber.toDouble();
  }

  static sendNotificationToDriver(String token, context, String rideRequestId) async{
    var destination = Provider.of<AppData>(context, listen: false).destinationLocation;
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken,
    };

    Map notificationMap = {
      'body': 'Destination : ${destination.placeName}',
      'title': 'New Ride Request'
    };

    Map dataMap= {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_request_id': rideRequestId,
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };
    
    var res = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
  }

  static String formatTripDate(String date){
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
    return formattedDate;
  }

  static void retrieveHistoryInfo(context){
    newRequestRef.orderByChild("riderName").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null){
        Map<dynamic, dynamic> keys = dataSnapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false).updateTripsCounter(tripCounter);

        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);
        obtainTripRequestsHistoryData(context);
      }
    });
  }

  static void obtainTripRequestsHistoryData(context){
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    for(String key in keys){
      newRequestRef.child(key).once().then((DataSnapshot snapshot){
        if(snapshot.value != null){

          newRequestRef.child(key).child("riderName").once().then((DataSnapshot dataSnapshot){
            String name = snapshot.value.toString();
            if(name == usersCurrentInfo.name){
              var history = History.fromSnapShot(snapshot);
              Provider.of<AppData>(context, listen: false).updateTripHistoryData(history);
            }
          });
        }
      });
    }
  }

}