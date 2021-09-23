import 'dart:convert';

import 'package:flutter/services.dart';

Future <List<CityData>> readCities() async {
  final String response = await rootBundle.loadString('assets/jordan_cities.json');
  final List<CityData> citiesData = await citiesDataFromJson(response);
  return citiesData;
}

List<CityData> citiesDataFromJson(String str) => List<CityData>.from(json.decode(str).map((x) => CityData.fromJson(x)));


class CityData {
  CityData({
    required this.id,
    required this.name,
    required this.country,
    required this.coord,
  });

  int id;
  String name;

  Country? country;
  Coord coord;

  factory CityData.fromJson(Map<String, dynamic> json) => CityData(
    id: json["id"],
    name: json["name"],

    country: countryValues.map[json["country"]],
    coord: Coord.fromJson(json["coord"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,

    "country": countryValues.reverse[country],
    "coord": coord.toJson(),
  };
}

class Coord {
  Coord({
    required this.lon,
    required this.lat,
  });

  double lon;
  double lat;

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
    lon: json["lon"].toDouble(),
    lat: json["lat"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lon": lon,
    "lat": lat,
  };
}

enum Country { JO }

final countryValues = EnumValues({
  "JO": Country.JO
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap = {};

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
