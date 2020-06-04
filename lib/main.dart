import './screens/splash_screen.dart';
import 'package:flutter/foundation.dart';

import './constant.dart';
import './provider/provider_dasboard.dart';
import './screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter/material.dart';
import 'provider/provider_dhaka.dart';
import 'provider/provider_district.dart';
import 'provider/provider_global.dart';
import 'screens/dhaka_screen.dart';
import 'screens/global.dart';
import 'screens/my_home_page.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      areSettingsEnabled: false,
      enabled: !kReleaseMode,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: DistrictData()),
        ChangeNotifierProvider.value(value: GlobalData()),
        ChangeNotifierProvider.value(value: DhakaData()),
        ChangeNotifierProvider.value(value: FetchBriefData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Covid 19 BD',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            bodyText2: TextStyle(color: kBodyTextColor),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: {
          GlobalScreen.routeName: (context) => GlobalScreen(),
          DhakaScreen.routeName: (context) => DhakaScreen(),
          MyHomePage.routeName: (context) => MyHomePage(),
          MainScreen.routeName: (context) => MainScreen(),
        },
      ),
    );
  }
}
