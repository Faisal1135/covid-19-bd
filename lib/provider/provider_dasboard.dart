import 'dart:convert';

import 'package:covid_19_bd/provider/provider_global.dart';
import 'package:flutter/foundation.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:http/http.dart' as http;

class CovidSummaryModel {
  String totalconf;
  String totalDeath;
  String todayconf;
  String todayDeath;
  String recoverd;
  String critical;
  String activeCase;
  String rationMillion;

  CovidSummaryModel({
    this.totalconf,
    this.totalDeath,
    this.todayconf,
    this.todayDeath,
    this.recoverd,
    this.critical,
    this.activeCase,
    this.rationMillion,
  });

  Map<String, String> toMap() {
    return {
      "Total Confirmed": totalconf,
      "Total Death": totalDeath,
      "New Affected": todayconf,
      "New Death": todayDeath,
      "Recoverd": recoverd,
      "critical": critical,
      "ratio": rationMillion,
    };
  }
}

class WorldData {
  String totalConf;
  String totalCountry;
  String totalDeath;
  String ref;

  WorldData({this.totalConf, this.totalCountry, this.totalDeath, this.ref});

  Map<String, String> toMap() {
    return {
      "Total Affected": totalConf,
      "Total Country": totalCountry,
      "Total Death": totalDeath,
    };
  }
}

class FetchBriefData extends ChangeNotifier {
  final dashwebScraper = WebScraper('http://103.247.238.81/webportal/pages');
  final prothomWebScraper = WebScraper('http://www.prothomalo.com/');
  final covidtracWebScraper = WebScraper('http://www.prothomalo.com/');

  CovidSummaryModel datamap;
  WorldData worldData;
  GlobalDataModel globalDataModel;

  Future<GlobalDataModel> fetchData() async {
    final reshtml = await http.get("http://covid19tracker.gov.bd/api/summary");
    final res = json.decode(reshtml.body) as List;
    final globa = res
        .map(
          (json) => GlobalDataModel.fromJson(json),
        )
        .firstWhere((gd) => gd.name == "Bangladesh");
    return globa;
  }

  Future<void> fetchProducts() async {
    List prothomWorlddatalist;

    if (await prothomWebScraper.loadWebPage('/')) {
      prothomWorlddatalist = prothomWebScraper
          .getElement('div.number', ["title"])
          .map((ele) => ele["title"])
          .toList();

      var banglaData = await fetchData();

      var newMap = CovidSummaryModel(
          totalconf: banglaData.totalCases != null
              ? banglaData.totalCases.toString()
              : prothomWorlddatalist[0],
          totalDeath: banglaData.totalDeaths != null
              ? banglaData.totalDeaths.toString()
              : prothomWorlddatalist[2],
          todayconf: banglaData.newCases != null
              ? banglaData.newCases.toString()
              : "Fetching..",
          todayDeath: banglaData.newDeaths != null
              ? banglaData.newDeaths.toString()
              : "Fetching..",
          recoverd: banglaData.totalRecovered != null
              ? banglaData.totalRecovered.toString()
              : prothomWorlddatalist[1],
          critical: banglaData.seriousCases.toString(),
          activeCase: banglaData.activeCases.toString(),
          rationMillion: banglaData.rationPerMillion);

      var newWorld = WorldData(
          totalConf: prothomWorlddatalist[4],
          totalCountry: prothomWorlddatalist[5],
          totalDeath: prothomWorlddatalist[6],
          ref: prothomWorlddatalist[7]);

      worldData = newWorld;
      datamap = newMap;
      notifyListeners();
    }
  }
}
