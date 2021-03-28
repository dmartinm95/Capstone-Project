import 'package:flutter/material.dart';
import '../../widgets/navigation_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String pageName = "HOME";
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            pageName,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white10,
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30.0),
              height: 200,
              width: size.width,
              color: Colors.white,
              child: Center(
                child: Text("EKG Real-Data Graph"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              height: 150,
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 150,
                    width: size.width * 0.35,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        "Heart Rate",
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: size.width * 0.35,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        "Blood Oxygen",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            NavigationBarWidget(),
          ],
        ),
      ),
    );
  }
}
