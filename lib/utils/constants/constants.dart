import 'package:google_maps_flutter/google_maps_flutter.dart';
const String adminEmail = "admin@gmail.com";

const defaultImageConstant = "Select Image";

const baseUrl = "https://fcm.googleapis.com";
const String apiKey =
    "key=AAAA-LFxSgk:APA91bEgUJ52n7LtLoKOxFGAl04pfdhyx-j-UiAD0yGjwCPdRcr3_12wMRb1t8C9NcX4M-nQtOpYy4_39V-jnvA1AjzPuksznYIgtuTsxVtuR3QuyPjsgy__RRsUkUlkvfEFFZIthmmO";

class TimeOutConstants {
  static int connectTimeout = 30;
  static int receiveTimeout = 25;
  static int sendTimeout = 60;
}

const List<MapType> maps = [
  MapType.terrain,
  MapType.normal,
  MapType.hybrid,
  MapType.satellite,
];

Map<dynamic,dynamic> mapsTypeName = {
  MapType.terrain.name: "terrain",
  MapType.normal.name: "normal",
  MapType.hybrid.name: "hybrid",
  MapType.satellite.name: "satellite",
};