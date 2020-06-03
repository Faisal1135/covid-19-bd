import 'package:covid_19_bd/screens/global.dart';

import '../provider/provider_global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalSearch extends SearchDelegate<String> {
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
    final searchList = Provider.of<GlobalData>(context)
        .globaldata
        .where(
          (data) => data.name.toLowerCase().startsWith(
                query.toLowerCase(),
              ),
        )
        .toList();
    return query.isEmpty ? Container() : buildListTile(searchList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchList = Provider.of<GlobalData>(context)
        .globaldata
        .where(
          (data) => data.name.toLowerCase().startsWith(
                query.toLowerCase(),
              ),
        )
        .toList();

    return query.isEmpty ? Container() : buildListTile(searchList);
  }

  Widget buildListTile(List<GlobalDataModel> searchList) {
    return ListView.builder(
      itemCount: searchList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () => Navigator.pushNamed(context, GlobalScreen.routeName,
              arguments: searchList[index].name),
          leading: Icon(Icons.flag),
          subtitle: Text(searchList[index].name),
          title: Text(searchList[index].bnName),
          trailing: CircleAvatar(
              backgroundColor: Colors.pink,
              maxRadius: 25,
              child: Text(
                searchList[index].totalCases.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
        );
      },
    );
  }
}
