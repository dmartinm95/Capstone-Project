import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class EKGResults extends StatefulWidget {
  EKGResults({Key key}) : super(key: key);

  @override
  _EKGResultsState createState() => _EKGResultsState();
}

class _EKGResultsState extends State<EKGResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Results",
          style: KardioCareAppTheme.screenTitleText,
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: KardioCareAppTheme.actionBlue,
            radius: 16,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.close),
              color: KardioCareAppTheme.background,
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 0),
              child: Container(
                height: 250,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 15, 19, 0),
              child: Text(
                "Stats",
              ),
            ),
            const Divider(
              color: KardioCareAppTheme.detailGray,
              height: 20,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 10),
              child: Container(
                height: 100,
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 15, 19, 0),
              child: Text(
                "Tags",
              ),
            ),
            const Divider(
              color: KardioCareAppTheme.detailGray,
              height: 20,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 130),
              child: Container(
                height: 200,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: KardioCareAppTheme.background,
        height: 70.0,
        child: Column(
          children: [
            const Divider(
              color: KardioCareAppTheme.detailGray,
              height: 1,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: KardioCareAppTheme.actionBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                    ),
                    // child: Padding(
                    // padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Run Analysis",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    // ),
                    onPressed: () {},
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      // shape: BeveledRectangleBorder(),
                    ),
                    // child: Padding(
                    // padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Restart",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    // ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
