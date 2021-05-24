import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
                color: KardioCareAppTheme.detailGray,
                borderRadius: BorderRadius.all(Radius.circular(200))),
            child: Icon(Icons.add_a_photo, color: Colors.white),
          ),
          Text(
            'First Last',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
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
            padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3 - 25,
                  child: Row(
                    children: [
                      Text('Age'),
                      Expanded(child: SizedBox()),
                      Text(
                        '-',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
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
            padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3 - 25,
                  child: Row(
                    children: [
                      Text('Height'),
                      Expanded(child: SizedBox()),
                      Text(
                        '-',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
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
            padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3 - 25,
                  child: Row(
                    children: [
                      Text('Weight'),
                      Expanded(child: SizedBox()),
                      Text(
                        '-',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: KardioCareAppTheme.detailGray,
            height: 20,
            thickness: 1,
            indent: 19,
            endIndent: 19,
          ),
          Container(
            height: 70,
            color: KardioCareAppTheme.background,
          ),
        ],
      ),
    );
  }
}
