import 'package:flutter/material.dart';
import 'package:kardio_care_app/screens/home/body.dart';
import 'package:kardio_care_app/screens/home/real_time_line_chart.dart';
import 'package:kardio_care_app/util/my_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        "Home Screen",
      ),
    );
  }
}
