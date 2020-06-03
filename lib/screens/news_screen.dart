import 'package:covid_19_bd/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';

enum NewsCat {
  Important,
  Covid,
}

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final controller = ScrollController();
  double offset = 0;

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

  Future<List<Map<String, String>>> getNewsMap(String baseurl) async {
    try {
      http.Response response = await http.get(baseurl);
      dom.Document document = parser.parse(response.body);
      var getnewsList = document
          .getElementsByClassName("title")
          .map((e) => {"title": e.text, "link": e.attributes["href"]})
          .toList();

      return getnewsList;
    } catch (e) {
      return List<Map<String, String>>();
    }
  }

  Future<Map<NewsCat, List<Map<String, String>>>> getAllNews() async {
    try {
      var importantNews =
          await getNewsMap("https://corona.gov.bd/corona-news?cat=24");
      var covidNews =
          await getNewsMap("https://corona.gov.bd/corona-news?cat=21");
      var covidNews2 =
          await getNewsMap("https://corona.gov.bd/corona-news?cat=21&page=2");
      covidNews.addAll(covidNews2);
      return {
        NewsCat.Important: importantNews,
        NewsCat.Covid: covidNews,
      };
    } catch (e) {
      throw e;
    }
  }

  Widget buildCardNews({String title, List<Map<String, String>> news}) {
    return Column(
      children: <Widget>[
        Card(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 100),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                title,
                style: kBanglaTextStyle.copyWith(fontSize: 28),
              ),
            ),
          ),
          elevation: 5,
          margin: const EdgeInsets.all(5),
        ),
        SizedBox(
          height: 20,
        ),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: news.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Card(
                  child: ExpansionTile(
                    title: RichText(
                      text: TextSpan(
                        style: kTitleTextstyle.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(text: news[index]["title"].split("-").first),
                          TextSpan(text: "  ⏩ "),
                          TextSpan(
                              text: news[index]["title"].split("-").last,
                              style: kBanglaTextStyle.copyWith(
                                  color: Colors.indigo)),
                        ],
                      ),
                    ),
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.new_releases,
                        color: Colors.amber,
                      ),
                      radius: 15,
                    ),
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          if (await canLaunch(news[index]["link"])) {
                            await launch(news[index]["link"]);
                          } else {
                            // throw 'Could not launch ';
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text("Cannot launch the url"),
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(news[index]["link"],
                              style: TextStyle(color: Colors.blueAccent)),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getAllNews(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<NewsCat, List<Map<String, String>>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            Text(snapshot.error.toString());
          }

          return ListView(
            children: <Widget>[
              MyHeader(
                image: "assets/icons/country.svg",
                textTop: "করোনা ভাইরাস",
                textBottom: "সম্পর্কিত সংবাদ",
                offset: offset,
                hasSearch: false,
              ),
              buildCardNews(
                  title: "করোনা সম্পর্কিত সংবাদ ",
                  news: snapshot.data[NewsCat.Covid]),
              SizedBox(
                height: 30,
              ),
              buildCardNews(
                  title: "জরুরি সংবাদ ",
                  news: snapshot.data[NewsCat.Important]),
            ],
          );
        },
      ),
    );
  }
}
