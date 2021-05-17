import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class HeartCalendar extends StatefulWidget {
  @override
  _HeartCalendarState createState() => _HeartCalendarState();
}

class _HeartCalendarState extends State<HeartCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KardioCareAppTheme.background,
      appBar: AppBar(
        title: Text(
          "Heart Calendar",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 50, 19, 0),
              child: Text(
                "Trends",
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
                height: 250,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 15, 19, 15),
              child: DailyStats(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 15, 19, 0),
              child: Text(
                "Todays Recordings",
              ),
            ),
            const Divider(
              color: KardioCareAppTheme.detailGray,
              height: 20,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return RecordingCard(context: context, index: index);
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 10),
              child: Container(
                height: 15,
                color: KardioCareAppTheme.background,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordingCard extends StatelessWidget {
  const RecordingCard({Key key, this.context, this.index}) : super(key: key);

  final BuildContext context;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Card(
              margin: EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                height: 75.0,
                color: Colors.green,
              ),
            ),
          ),
          Positioned(
            top: index > 0 ? 0.0 : 50.0,
            bottom: index == 4 ? 50.0 : 0.0,
            left: 35.0,
            child: Container(
                height: double.infinity, width: 1.0, color: Colors.black),
          ),
          Positioned(
            top: 35.0,
            left: 15.0,
            child: Container(
              height: 40.0,
              width: 40.0,
              child: Container(
                margin: EdgeInsets.all(5.0),
                height: 30.0,
                width: 30.0,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DailyStats extends StatelessWidget {
  const DailyStats({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Stats'),
          const Divider(
            color: KardioCareAppTheme.detailGray,
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Row(
                  children: [
                    Text('Avg HR'),
                    Expanded(child: SizedBox()),
                    Text(
                      '78 Bpm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Row(
                  children: [
                    Text('Avg O2 %'),
                    Expanded(child: SizedBox()),
                    Text(
                      '96 %',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: KardioCareAppTheme.detailGray,
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Row(
                  children: [
                    Text('Min HR'),
                    Expanded(child: SizedBox()),
                    Text(
                      '51 Bpm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Row(
                  children: [
                    Text('at'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '7 am',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: KardioCareAppTheme.detailGray,
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Row(
                  children: [
                    Text('Max HR'),
                    Expanded(child: SizedBox()),
                    Text(
                      '170 Bpm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Row(
                  children: [
                    Text('at'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '7:45 am',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: KardioCareAppTheme.detailGray,
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Row(
                  children: [
                    Text('Min O2 %'),
                    Expanded(child: SizedBox()),
                    Text(
                      '95 %',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 25,
                child: Row(
                  children: [
                    Text('at'),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '8 am',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
