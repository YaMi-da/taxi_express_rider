import 'package:flutter/material.dart';
import 'package:taxi_express_rider/Models/addresses.dart';
import 'package:taxi_express_rider/Models/history.dart';


class AppData extends ChangeNotifier{
  Address pickUpLocation, destinationLocation;

  String profit = "0";
  int countTrip = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];

  void updatePickUpLocationAddress(Address pickUpAddress){
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDestinationLocationAddress(Address destinationAdress){
    destinationLocation = destinationAdress;
    notifyListeners();
  }

  void updateProfit(String updatedProfit){
    profit = updatedProfit;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter){
    countTrip = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys ){
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory ){
    tripHistoryDataList.add(eachHistory);
    notifyListeners();
  }
}