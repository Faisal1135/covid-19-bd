import 'package:flutter/material.dart';

import '../constant.dart';

class ShowDataTable extends StatelessWidget {
  final List<Map<String, String>> dataMap;
  const ShowDataTable({Key key, this.dataMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(columns: [
      DataColumn(
          label: Text(
        "এলাকা",
        style: kBanglaTextStyle,
      )),
      DataColumn(
        label: Text(
          "আক্রান্ত",
          style: kBanglaTextStyle,
        ),
      ),
    ], rows: buildDataRowList(dataMap));
  }

  List<DataRow> buildDataRowList(List<Map<String, String>> dataMap) {
    var takeDataRowList = List<DataRow>();
    takeDataRowList = dataMap
        .map((map) => DataRow(cells: [
              DataCell(Text(
                map.keys.first,
                style: kBanglaTextStyle,
              )),
              DataCell(Text(
                map.values.first,
                style: kTitleTextstyle,
              ))
            ]))
        .toList();
    return takeDataRowList;

    // dataMap.forEach((dist, number) {
    //   var newDataRow = DataRow(
    //     cells: [
    //       DataCell(Text(dist)),
    //       DataCell(
    //         Text(number),
    //       ),
    //     ],
    //   );
    //   takeDataRowList.add(newDataRow);
    // });
    // return takeDataRowList;
  }
}
