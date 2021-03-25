import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:taxi_express_rider/Assistants/requestAssistant.dart';
import 'package:taxi_express_rider/Models/addresses.dart';
import 'package:taxi_express_rider/Data/appData.dart';
import 'package:taxi_express_rider/Models/directionDetails.dart';

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

}