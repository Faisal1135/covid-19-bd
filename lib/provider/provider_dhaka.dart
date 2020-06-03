import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DhakaDataModel {
  String name;
  String confirmed;
  String bnName;

  DhakaDataModel(this.name, this.confirmed, this.bnName);

  DhakaDataModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        confirmed = json["confirmed"].toString(),
        bnName = json["bnName"] == null ? json["name"] : json["bnName"];

  Map<String, String> toMap() {
    return {bnName: confirmed};
  }
}

class DhakaData extends ChangeNotifier {
  var _dhakalist = List<DhakaDataModel>();

  List<DhakaDataModel> get alldata => [..._dhakalist];

  Future<void> fetchData() async {
    final res = await http.get("http://covid19tracker.gov.bd/api/dhaka");
    final dhakalist = json.decode(res.body) as List;
    List<DhakaDataModel> alldhakadata =
        dhakalist.map((json) => DhakaDataModel.fromJson(json)).toList();

    _dhakalist = alldhakadata;
    notifyListeners();
  }
}
