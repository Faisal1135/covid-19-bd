import 'package:covid_19_bd/provider/provider_dhaka.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class DhakaSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchList = Provider.of<DhakaData>(context)
        .alldata
        .where(
          (data) => data.name.toLowerCase().startsWith(
                query.toLowerCase(),
              ),
        )
        .toList();
    return searchList.isEmpty
        ? Center(
            child: Text("No content Found"),
          )
        : buildListTile(searchList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchList = Provider.of<DhakaData>(context)
        .alldata
        .where(
          (data) => data.name.toLowerCase().startsWith(
                query.toLowerCase(),
              ),
        )
        .toList();

    return query.isEmpty ? Container() : buildListTile(searchList);
  }

  Widget buildListTile(List<DhakaDataModel> searchList) {
    return ListView.builder(
      itemCount: searchList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.location_city),
            radius: 20,
          ),
          // contentPadding: EdgeInsets.all(10),
          title: Text(
            searchList[index].bnName,
            style: kBanglaTextStyle.copyWith(fontSize: 25, wordSpacing: 1),
          ),
          trailing: Container(
            child: Text(
              searchList[index].confirmed,
              style: kTitleTextstyle.copyWith(color: Colors.white),
            ),
            decoration: BoxDecoration(
                color: Colors.pink.shade400,
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(3), right: Radius.circular(3))),
          ),
        );
      },
    );
  }
}
