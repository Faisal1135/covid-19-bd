import 'package:covid_19_bd/provider/provider_dhaka.dart';
import 'package:covid_19_bd/widgets/datatable.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/dhaka_search.dart';

class DhakaScreen extends StatefulWidget {
  static const routeName = "/dhaka-screen";

  @override
  _DhakaScreenState createState() => _DhakaScreenState();
}

class _DhakaScreenState extends State<DhakaScreen> {
  // bool run = true;
  // final controller = ScrollController();
  // double offset = 0;
  // String selectedDistict;

  // @override
  // void initState() {
  //   super.initState();
  //   controller.addListener(onScroll);
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  // void onScroll() {
  //   setState(() {
  //     offset = (controller.hasClients) ? controller.offset : 0;
  //   });
  // }

  _refreshAndFetchData(context) =>
      Provider.of<DhakaData>(context, listen: false).fetchData();

  bool _needToLoad(context) =>
      Provider.of<DhakaData>(context).alldata.length == 0;

  Widget buildPageBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshAndFetchData(context),
      child: Consumer<DhakaData>(
        builder: (_, data, __) => CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Dhaka',
                          style: TextStyle(
                              backgroundColor: Colors.black38,
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showSearch(
                                context: context, delegate: DhakaSearch());
                          }),
                    ],
                  ),
                ),
                background: Container(
                    color: Colors.deepPurple,
                    child: AnimatedDrawing.svg(
                      "assets/icons/dhaka.svg",
                      run: true,
                      duration: Duration(seconds: 3),
                    )),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(
                height: 20,
              ),
              ShowDataTable(
                dataMap: data.alldata.map((dhaka) => dhaka.toMap()).toList(),
              )
            ]))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _needToLoad(context)
            ? FutureBuilder(
                future: _refreshAndFetchData(context),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  return buildPageBody(context);
                },
              )
            : buildPageBody(context));
  }
}
