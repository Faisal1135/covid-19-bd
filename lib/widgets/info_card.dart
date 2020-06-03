import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String effectedNum;
  final Color iconColor;
  final Function press;
  const InfoCard({
    Key key,
    this.title,
    this.effectedNum,
    this.iconColor,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: press,
          child: Container(
            width: constraints.maxWidth / 2 - 10,
            // Here constraints.maxWidth provide us the available width for the widget
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/running.svg",
                          height: 12,
                          width: 12,
                          color: iconColor,
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          title,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      effectedNum,
                      style: kBanglaTextStyle.copyWith(fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
