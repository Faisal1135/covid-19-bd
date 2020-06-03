import 'package:covid_19_bd/widgets/counter.dart';
import 'package:covid_19_bd/widgets/info_card.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

import '../constant.dart';
import '../provider/provider_dasboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBorardScreen extends StatefulWidget {
  @override
  _DashBorardScreenState createState() => _DashBorardScreenState();
}

class _DashBorardScreenState extends State<DashBorardScreen> {
  List<InfoCard> buildListTiles(Map<String, String> map) {
    var listTiles = List<InfoCard>();
    map.forEach((key, value) {
      var newListTile = InfoCard(
        title: key,
        effectedNum: value,
        iconColor: kInfectedColor,
        press: null,
      );

      listTiles.add(newListTile);
    });
    return listTiles;
  }

  bool _needToLoad(context) =>
      Provider.of<FetchBriefData>(context).datamap == null;
  Widget buildBody() {
    return RefreshIndicator(
      onRefresh: () =>
          Provider.of<FetchBriefData>(context, listen: false).fetchProducts(),
      child: Consumer<FetchBriefData>(
        builder: (BuildContext context, FetchBriefData data, Widget ch) {
          final datamap = data.datamap;
          final worldmap = data.worldData;
          final w = MediaQuery.of(context).size.width;

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Container(
                    child: Align(
                      child: Text(
                        "ড্যাশবোর্ড",
                        style: kBanglaTextStyle.copyWith(fontSize: 26),
                      ),
                      alignment: Alignment.bottomLeft,
                    ),
                    // padding: const EdgeInsets.all(20),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )),
                    child: AnimatedDrawing.svg(
                      "assets/icons/covid-bd-logo.svg",
                      run: true,
                      duration: Duration(seconds: 3),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    buildTitleCard("শেষ ২৪ ঘন্টায় ", 26),
                    StaggeredGridView.count(
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      crossAxisCount: 2,
                      children: <Widget>[
                        Counter(
                          number: datamap.todayconf,
                          color: Colors.red,
                          title: "নতুন আক্রান্ত",
                          icon: Icons.add_box,
                        ),
                        Counter(
                          number: datamap.todayDeath,
                          color: Colors.deepPurple,
                          title: "‌নতুন মৃত",
                          icon: Icons.remove_circle,
                        ),
                      ],
                      staggeredTiles: [
                        StaggeredTile.extent(1, w / 2),
                        StaggeredTile.extent(1, w / 2),
                      ],
                    ),
                    buildTitleCard("বাংলাদেশ", 28),
                    StaggeredGridView.count(
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      crossAxisCount: 3,
                      children: <Widget>[
                        Counter(
                            number: datamap.totalconf,
                            color: Colors.red,
                            title: "মোট আক্রান্ত"),
                        Counter(
                            number: datamap.totalDeath,
                            color: Colors.black,
                            title: "মোট মৃত"),
                        Counter(
                            number: datamap.activeCase,
                            color: Colors.green,
                            title: "চিকিৎসাধীন"),
                        Counter(
                            number: datamap.critical,
                            color: Colors.green,
                            title: "সংকটপূর্ণ"),
                        Counter(
                            number: datamap.rationMillion,
                            color: Colors.green,
                            title: "প্রতি ১০ \n লক্ষে আক্রান্ত"),
                        Counter(
                            number: datamap.recoverd,
                            color: Colors.deepPurple,
                            title: "মোট সুস্থ"),
                      ],
                      staggeredTiles: [
                        StaggeredTile.extent(1, w / 3),
                        StaggeredTile.extent(1, w / 3),
                        StaggeredTile.extent(1, w / 3),
                        StaggeredTile.extent(1, w / 3),
                        StaggeredTile.extent(2, w / 2),
                        StaggeredTile.extent(1, w / 2),
                      ],
                    ),
                    buildTitleCard("বিশ্বব্যাপি ", 26),
                    StaggeredGridView.count(
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      crossAxisCount: 2,
                      children: <Widget>[
                        Counter(
                            number: worldmap.totalConf,
                            color: Colors.red,
                            title: "মোট আক্রান্ত"),
                        Counter(
                            number: worldmap.totalDeath,
                            color: Colors.black,
                            title: "মোট মৃত"),
                        Counter(
                            number: worldmap.totalCountry,
                            color: Colors.amber,
                            title: "মোট দেশ "),
                        Counter(
                          number: worldmap.ref,
                          icon: Icons.pageview,
                          color: Colors.deepPurple,
                          title: "",
                        ),
                      ],
                      staggeredTiles: [
                        StaggeredTile.extent(1, w / 2),
                        StaggeredTile.extent(1, w / 2),
                        StaggeredTile.extent(1, w / 2),
                        StaggeredTile.extent(1, w / 2),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "লক্ষণ",
                            style: kBanglaTextStyle.copyWith(fontSize: 30),
                          ),
                          SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SymptomCard(
                                  image: "assets/images/headache.png",
                                  title: "জ্বর",
                                  isActive: true,
                                ),
                                SymptomCard(
                                  image: "assets/images/caugh.png",
                                  title: "কাশি",
                                ),
                                SymptomCard(
                                  image: "assets/images/fever.png",
                                  title: "মাথাব্যথা",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("করোনা প্রতিরোধ", style: kTitleTextstyle),
                          SizedBox(height: 20),
                          PreventCard(
                            text:
                                "বাহিরে যাবার পূর্বে মাস্ক পরিধান করুন এবং সাবধানতার সাথে মাস্কটি খুলুন",
                            image: "assets/images/mask.jpg",
                            title: "মাস্ক পরিধান করুন",
                          ),
                          PreventCard(
                            text:
                                "সাবান দিয়ে নিয়মিত অন্তত ২০ সেকেন্ড যাবৎ হাত ধৌত করুন",
                            image: "assets/images/wash_hand.png",
                            title: "হাত ধৌত করুন",
                          ),
                          PreventCard(
                            text: "বেশি বেশি ক্ষমা প্রার্থনা এবং দোয়া করুন ",
                            image: "assets/images/praying.png",
                            title: "প্রার্থনা করুন",
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _needToLoad(context)
        ? FutureBuilder(
            future: Provider.of<FetchBriefData>(context, listen: false)
                .fetchProducts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                      'Something Went Wrong !!! \n Please check your internet Connections !!!'),
                );
              }

              return buildBody();
            },
          )
        : buildBody();
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 136,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 130,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kBanglaTextStyle.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset("assets/icons/forward.svg"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isActive;
  const SymptomCard({
    Key key,
    this.image,
    this.title,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          isActive
              ? BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: kActiveShadowColor,
                )
              : BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: kShadowColor,
                ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 90),
          Text(
            title,
            style: kBanglaTextStyle, //TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Column(
//               children: <Widget>[
//                 Text(datamap.totalconf + "= Totaldatamap.toMap().forEach((key, value) { }) Confirm"),
//                 Text(datamap.todayDeath + " Total death"),
//                 Text(datamap.totalquarentine + " total qua"),
//                 Text(datamap.relesefromQuarentine + " relese"),
//                 Text(datamap.todayDeath + " today death"),
//                 Text(datamap.todayconf + " today conf"),
//                 Text(datamap.todaylabtest + " today lab"),
//               ],
//             );
