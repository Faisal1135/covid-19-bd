import '../constant.dart';
import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final String number;
  final Color color;
  final String title;
  final IconData icon;

  Counter({
    Key key,
    this.icon,
    this.number,
    this.color,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: kActiveShadowColor,

      // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(.26),
                ),
                child: Icon(icon != null ? icon : Icons.people_outline)),
            Text(
              number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: color,
              ),
            ),
            Text(
              title,
              style: kBanglaTextStyle.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
