import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DistrictDataModel {
  final uid;
  final String name;
  final String bnName;
  final String confirmed;
  final String key;

  DistrictDataModel(
      {@required this.uid,
      @required this.name,
      @required this.bnName,
      @required this.confirmed,
      @required this.key});
  Map<String, String> toMap() => {bnName: confirmed};
}

class DistrictData extends ChangeNotifier {
  List<DistrictDataModel> _disdata = [];

  List<DistrictDataModel> get alldist => [..._disdata];

  Future<void> fetchData() async {
    final reshtml = await http.get("http://covid19tracker.gov.bd/api/district");
    final res = json.decode(reshtml.body);
    List<DistrictDataModel> alldata = [];
    for (var dist in res["features"]) {
      final fetchdata = dist["properties"];
      final newDisctData = DistrictDataModel(
          uid: fetchdata["uid"],
          name: fetchdata["name"],
          bnName: fetchdata["bnName"],
          confirmed: fetchdata["confirmed"],
          key: fetchdata["key"]);

      alldata.add(newDisctData);
    }
    _disdata = alldata;
    notifyListeners();
    // print(res["features"][1]["properties"]);
  }
}
