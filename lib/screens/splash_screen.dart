import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:covid_19_bd/screens/main_screen.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Stack(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.4),
            color: Colors.indigo,
            child: TextLiquidFill(
                text: 'করোনা ট্র্যাকার বিডি',
                waveColor: Color(0xffADFF00),
                loadDuration: Duration(seconds: 4),
                boxBackgroundColor: Colors.indigoAccent,
                textStyle: kBanglaTextStyle.copyWith(
                    fontSize: 40, color: Colors.amber)),
          ),
          Container(
            child: AnimatedDrawing.svg(
              "assets/icons/covid-bd-logo.svg",
              run: true,
              duration: Duration(seconds: 3),
              onFinish: () =>
                  Navigator.pushReplacementNamed(context, MainScreen.routeName),
            ),
          ),
        ],
      ),
    );
  }
}
