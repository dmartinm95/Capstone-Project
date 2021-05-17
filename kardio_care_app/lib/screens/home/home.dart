import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.red,
              ),
            ),
          ),
          const Divider(
            color: KardioCareAppTheme.detailGray,
            height: 25,
            thickness: 1,
            indent: 19,
            endIndent: 19,
          ),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9.5, 0, 9.5, 100),
                      child: Container(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 25,
                    thickness: 1,
                    indent: 20,
                    endIndent: 120,
                    color: KardioCareAppTheme.detailGray,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9.5, 0, 9.5, 100),
                      child: Container(
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
