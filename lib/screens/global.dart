import 'package:covid_19_bd/provider/provider_global.dart';
import 'package:covid_19_bd/widgets/counter.dart';
import 'package:covid_19_bd/widgets/datatable.dart';
import 'package:covid_19_bd/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class GlobalScreen extends StatefulWidget {
  static const routeName = "/global-page";

  @override
  _GlobalScreenState createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen> {
  final controller = ScrollController();
  double offset = 0;
  String selectedCountry;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  bool needToFetch(BuildContext context) {
    var globdata = Provider.of<GlobalData>(context, listen: false).globaldata;
    return globdata.length == 0;
  }

  List<Map<String, String>> buildTopAffectedCount(
      List<GlobalDataModel> datalist) {
    var data = [...datalist];
    data.sort((a, b) => a.totalCases.compareTo(b.totalCases));
    data = data.reversed.toList();
    var dataten = data
        .sublist(0, 11)
        .map((e) => {e.bnName: e.totalCases.toString()})
        .toList();
    return dataten;
  }

  ExpansionTile buildExpantionTile(GlobalDataModel data) {
    return ExpansionTile(
      title: Text(data.bnName),
      children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("TotalCases"),
                trailing: Text(data.totalCases.toString()),
              ),
              ListTile(
                title: Text("New Cases"),
                trailing: Text(data.newCases.toString()),
              ),
              ListTile(
                title: Text("Total Death"),
                trailing: Text(data.totalDeaths.toString()),
              ),
            ],
          ),
        )
      ],
    );
  }

  List<Counter> getCounter(Map<String, String> map) {
    var finalCouter = List<Counter>();

    // var selecMod = getInfectedText(selectedCountry, maplist);

    map.forEach((title, number) {
      var newCout = Counter(
        title: title,
        number: number,
        color: kInfectedColor,
      );
      finalCouter.add(newCout);
    });
    return finalCouter;
  }

  GlobalDataModel getInfectedText(
      String selectedDistict, List<GlobalDataModel> alldistData) {
    var selectItem =
        selectedDistict == null ? alldistData.first.name : selectedDistict;
    var selectModel =
        alldistData.where((element) => element.name == selectItem).first;
    return selectModel;
  }

  Widget buildPageBody(BuildContext context, [String searchcountry]) {
    return RefreshIndicator(
      onRefresh: () async => await _refreshandFetchData(context),
      child: Consumer<GlobalData>(
        builder: (BuildContext context, GlobalData data, Widget child) {
          var alldistData = [...data.globaldata];

          alldistData.sort(
            (a, b) => a.name.compareTo(
              b.name,
            ),
          );

          if (searchcountry != null) {
            selectedCountry = searchcountry;
          }

          final w = MediaQuery.of(context).size.width;
          // alldistData = alldistData.reversed.toList();
          var getval = selectedCountry == null
              ? alldistData.first.name
              : selectedCountry;
          var datamap = getInfectedText(selectedCountry, alldistData);
          return Scaffold(
            body: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: <Widget>[
                  MyHeader(
                    image: "assets/icons/worldmap.svg",
                    textTop: "বিশ্বব্যাপী করোনা",
                    textBottom: "ভাইরাস পরিস্থিতি",
                    offset: offset,
                    hasSearch: true,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButton(
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                            value: getval,
                            items: alldistData.map<DropdownMenuItem<String>>(
                                (GlobalDataModel value) {
                              return DropdownMenuItem<String>(
                                value: value.name,
                                child: Text(
                                  value.bnName,
                                  style: kBanglaTextStyle,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCountry = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Container(child: Text('Last Update')),
                  Card(
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: 50),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "শেষ ২৪ ঘন্টায়",
                          style: kBanglaTextStyle.copyWith(fontSize: 26),
                        ),
                      ),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(5),
                  ),
                  StaggeredGridView.count(
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    crossAxisCount: 3,
                    children: <Widget>[
                      Counter(
                        number: datamap.newCases.toString(),
                        color: Colors.red,
                        title: "নতুন আক্রান্ত",
                        icon: Icons.add_box,
                      ),
                      Counter(
                        number: datamap.newDeaths.toString(),
                        color: Colors.deepPurple,
                        title: "‌নতুন মৃত",
                        icon: Icons.remove_circle,
                      ),
                    ],
                    staggeredTiles: [
                      StaggeredTile.extent(1, w / 3),
                      StaggeredTile.extent(1, w / 3),
                    ],
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: 50),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          "বিস্তারিত",
                          style: kBanglaTextStyle.copyWith(fontSize: 30),
                        ),
                      ),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(5),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        StaggeredGridView.count(
                          primary: false,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(10),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          crossAxisCount: 3,
                          children: <Widget>[
                            Counter(
                                number: datamap.totalCases.toString(),
                                color: Colors.red,
                                title: "মোট আক্রান্ত"),
                            Counter(
                                number: datamap.totalDeaths.toString(),
                                color: Colors.black,
                                title: "মোট মৃত"),
                            Counter(
                                number: datamap.activeCases.toString(),
                                color: Colors.green,
                                title: "চিকিৎসাধীন"),
                            Counter(
                                number: datamap.seriousCases.toString(),
                                color: Colors.green,
                                title: "সংকটপূর্ণ"),
                            Counter(
                                number: datamap.rationPerMillion.toString(),
                                color: Colors.green,
                                title: "প্রতি ১০ \n লক্ষে আক্রান্ত"),
                            Counter(
                                number: datamap.totalRecovered.toString(),
                                color: Colors.deepPurple,
                                title: "মোট সুস্থ"),
                          ],
                          staggeredTiles: [
                            StaggeredTile.extent(2, w / 3),
                            StaggeredTile.extent(1, w / 3),
                            StaggeredTile.extent(2, w / 3),
                            StaggeredTile.extent(2, w / 3),
                            StaggeredTile.extent(2, w / 2),
                            StaggeredTile.extent(1, w / 2),
                          ],
                        ),
                        buildTitleCard("সর্বাধিক আক্রান্ত ১০ দেশ"),
                        ShowDataTable(
                          dataMap: buildTopAffectedCount(alldistData),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshandFetchData(BuildContext context) async =>
      await Provider.of<GlobalData>(context, listen: false).fetchData();

  @override
  Widget build(BuildContext context) {
    final searchcountry = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      body: needToFetch(context)
          ? FutureBuilder(
              future: _refreshandFetchData(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Somethings Went Wrong !! \n please check your \n internet connections !!!"),
                  );
                }

                return buildPageBody(context, searchcountry);
              })
          : buildPageBody(context, searchcountry),
    );
  }
}
