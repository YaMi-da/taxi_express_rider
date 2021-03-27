import 'package:taxi_express_rider/Models/nearbyAvailableDrivers.dart';

class GeoFireAssistant{
  static List<NearbyAvailableDrivers> nearbyAvailableDriversList = [];
  static void removeDriverFromList(String key){
    int index = nearbyAvailableDriversList.indexWhere((element) => element.key == key);
    nearbyAvailableDriversList.remove(index);
  }
  static void updateNearbyDriverLocation(NearbyAvailableDrivers drivers){
    int index = nearbyAvailableDriversList.indexWhere((element) => element.key == drivers.key);
    nearbyAvailableDriversList[index].latitude = drivers.latitude;
    nearbyAvailableDriversList[index].longitude = drivers.longitude;
  }
}