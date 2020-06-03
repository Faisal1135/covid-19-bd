import 'package:covid_19_bd/screens/dhaka_screen.dart';
import 'package:covid_19_bd/widgets/counter.dart';
import 'package:covid_19_bd/widgets/datatable.dart';
import 'package:covid_19_bd/widgets/my_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant.dart';

import '../provider/provider_district.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = "/district-page";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = ScrollController();
  double offset = 0;
  String selectedDistict;

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

  String getInfectedText(
      String selectedDistict, List<DistrictDataModel> alldistData) {
    var selectItem =
        selectedDistict == null ? alldistData.first.bnName : selectedDistict;
    var selectModel =
        alldistData.where((element) => element.bnName == selectItem).first;
    return selectModel.confirmed;
  }

  Future<void> _refreshtoFetch(BuildContext context) async =>
      await Provider.of<DistrictData>(context, listen: false).fetchData();

  bool _needToload(context) =>
      Provider.of<DistrictData>(context).alldist.length == 0;

  Widget buildBangladeshData(BuildContext context) => RefreshIndicator(
        onRefresh: () => _refreshtoFetch(context),
        child: Consumer<DistrictData>(
          builder: (_, data, ch) {
            var alldistData = [...data.alldist];
            alldistData.sort(
              (a, b) => int.parse(a.confirmed).compareTo(
                int.parse(b.confirmed),
              ),
            );
            alldistData = alldistData.reversed.toList();
            var getval = selectedDistict == null
                ? alldistData.first.bnName
                : selectedDistict;

            return Scaffold(
              body: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: <Widget>[
                    MyHeader(
                      image: "assets/icons/country.svg",
                      textTop: "বাংলাদশের",
                      textBottom: "করোনা পরিস্থিতি",
                      offset: offset,
                      hasSearch: false,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                              icon:
                                  SvgPicture.asset("assets/icons/dropdown.svg"),
                              value: getval,
                              items: alldistData.map<DropdownMenuItem<String>>(
                                  (DistrictDataModel value) {
                                return DropdownMenuItem<String>(
                                  value: value.bnName,
                                  child: Text(
                                    value.bnName,
                                    style: kBanglaTextStyle,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedDistict = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          ExpansionTile(
                            title: Text(
                              "সকল জেলা",
                              style: kBanglaTextStyle.copyWith(fontSize: 25),
                            ),
                            trailing: Text(
                              "বিস্তারিত",
                              style: kBanglaTextStyle.copyWith(
                                  color: Colors.lightBlueAccent),
                            ),
                            children: <Widget>[
                              ShowDataTable(
                                dataMap:
                                    alldistData.map((e) => e.toMap()).toList(),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 30,
                                  color: kShadowColor,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Counter(
                                  color: kInfectedColor,
                                  number: getInfectedText(
                                      selectedDistict, alldistData),
                                  title: "আক্রান্ত",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DhakaScreen())),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "ঢাকার করোনা পরিস্থিতি",
                                        style: kBanglaTextStyle.copyWith(
                                            fontSize: 26),
                                      ),
                                      Text(
                                        "বিস্তারিত",
                                        style: kBanglaTextStyle.copyWith(
                                          color: kPrimaryColor,
                                          // fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.all(20),
                                    height: 178,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 10),
                                          blurRadius: 30,
                                          color: kShadowColor,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                            "Dhaka \n ${alldistData.first.confirmed}"),
                                        Expanded(
                                          child: SvgPicture.asset(
                                            "assets/icons/dhaka.svg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _needToload(context)
            ? FutureBuilder(
                future: _refreshtoFetch(context),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.hasData) {
                    return buildBangladeshData(context);
                  }
                  return Center(
                    child: Text(
                        "Somethings Went Wrong !! \n please check your \n internet connections !!!"),
                  );
                },
              )
            : buildBangladeshData(context));
  }
}

// ListView(
//               children: <Widget>[
//                 Card(
//                   child: Container(
//                     child: const Text("District of Bangladesh"),
//                   ),
//                 ),
//                 ListView.builder(
//                   primary: false,
//                   shrinkWrap: true,
//                   itemCount: alldistData.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final distdata = alldistData[index];
//                     return Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           Text(
//                             distdata.bnName,
//                             style: kBanglaTextStyle.copyWith(fontSize: 20),
//                           ),
//                           Text(
//                             distdata.confirmed,
//                             style: kTitleTextstyle,
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             );

// ListView(
//             children: <Widget>[
//               Card(
//                 child: Container(
//                   child: Text("District of Bangladesh"),
//                 ),
//               ),
//               ListView.builder(
//                 primary: false,
//                 shrinkWrap: true,
//                 itemCount: data.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ListTile(
//                     title: Text(data[index].bnName),
//                     trailing: Text(data[index].confirmed),
//                   );
//                 },
//               ),
//             ],
//           );
