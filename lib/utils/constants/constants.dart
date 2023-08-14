import 'package:google_maps_flutter/google_maps_flutter.dart';
const String adminEmail = "admin@gmail.com";

const defaultImageConstant = "Select Image";

const baseUrl = "https://geocode-maps.yandex.ru";
const String apiKey = "0966317a-0c56-4ae7-a7ee-eda74212af4d";

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

const List<String> kindList = [
  "house",
  "metro",
  "district",
  "street",
];

const List<String> langList = [
  "uz_UZ",
  "ru_RU",
  "en_GB",
  "tr_TR",
];

const List<String> language = [
  "Uzbek",
  "Rus",
  "Ingliz",
  "Turk"
];