import 'package:covid_19_bd/screens/my_home_page.dart';
import 'package:covid_19_bd/screens/news_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './dashbord_screen.dart';

import 'global.dart';

class MainScreen extends StatefulWidget {
  static const routeName = "/main-screen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: pageIndex);
  }

  void onChangePage(int index) {
    setState(() {
      this.pageIndex = index;
    });
  }

  void _onTap(int value) {
    _pageController.animateToPage(value,
        curve: Curves.bounceInOut, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), title: Text('ড্যাশবোর্ড')),
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text('বাংলাদেশ')),
          BottomNavigationBarItem(
              icon: Icon(Icons.map), title: Text('বিশ্বব্যাপী')),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text('সংবাদ ')),
        ],
        currentIndex: pageIndex,
        onTap: _onTap,
      ),
      body: PageView(
        children: <Widget>[
          DashBorardScreen(),
          MyHomePage(),
          GlobalScreen(),
          NewsScreen(),
        ],
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onChangePage,
      ),
    );
  }
}
