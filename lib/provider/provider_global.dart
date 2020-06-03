import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GlobalDataModel {
  int seriousCases;
  int activeCases;
  int newDeaths;
  int totalRecovered;
  int totalCases;
  int newCases;
  int totalDeaths;
  String rationPerMillion;
  String latitude;
  String name;
  String bnName;
  String longitude;

  GlobalDataModel(
      {@required this.seriousCases,
      @required this.activeCases,
      @required this.newDeaths,
      @required this.totalRecovered,
      @required this.latitude,
      @required this.name,
      @required this.bnName,
      @required this.totalCases,
      @required this.newCases,
      @required this.totalDeaths,
      @required this.rationPerMillion,
      this.longitude});

  GlobalDataModel.fromJson(Map json)
      : seriousCases = json["SeriousCases"] == null ? 0 : json["SeriousCases"],
        activeCases = json["ActiveCases"] == null ? 0 : json["ActiveCases"],
        newDeaths = json["NewDeaths"] == null ? 0 : json["NewDeaths"],
        totalRecovered =
            json["TotalRecovered"] == null ? 0 : json["TotalRecovered"],
        latitude = json["latitude"],
        name = json["name"],
        bnName = json["bnName"],
        totalCases = json["TotalCases"] == null ? 0 : json["TotalCases"],
        newCases = json["NewCases"] == null ? 0 : json["NewCases"],
        totalDeaths = json["TotalDeaths"] == null ? 0 : json["TotalDeaths"],
        rationPerMillion = json["RationPerMillion"] == null
            ? 0.toString()
            : json["RationPerMillion"].toString(),
        longitude = json["longitude"];

  Map<String, String> genareltoMap() {
    return {
      "মোট আক্রান্ত": totalCases.toString(),
      "মোট মৃত": totalDeaths.toString(),
      "সংকটপূর্ণ": seriousCases.toString(),
      "চিকিৎসাধীন": activeCases.toString(),
      "মোট সুস্থ": totalRecovered.toString(),
      "প্রতি ১০ লক্ষে আক্রান্ত ": rationPerMillion,
    };
  }

  Map<String, String> newltoMap() {
    return {
      "নতুন সংক্রমণ": newCases.toString(),
      "নতুন মৃত": newDeaths.toString(),
    };
  }
}

class GlobalData extends ChangeNotifier {
  List<GlobalDataModel> _global = [];

  List<GlobalDataModel> get globaldata => [..._global];

  Future<void> fetchData() async {
    final reshtml = await http.get("http://covid19tracker.gov.bd/api/summary");
    final res = json.decode(reshtml.body) as List;
    final allGlobal = res
        .map(
          (json) => GlobalDataModel.fromJson(json),
        )
        .toList();
    _global = allGlobal;
    notifyListeners();
  }
}
