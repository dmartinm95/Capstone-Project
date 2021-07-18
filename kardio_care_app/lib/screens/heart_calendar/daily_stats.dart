import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class DailyStats extends StatelessWidget {
  const DailyStats({
    Key key,
    this.avgHR,
    this.minHR,
    this.minHRTime,
    this.maxHR,
    this.maxHRTime,
  }) : super(key: key);

  final int avgHR;
  final int minHR;
  final String minHRTime;
  final int maxHR;
  final String maxHRTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Stats',
            style: KardioCareAppTheme.subTitle,
          ),
          const Divider(
            color: KardioCareAppTheme.dividerPurple,
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
                      (avgHR ?? "--").toString() + ' Bpm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: KardioCareAppTheme.dividerPurple,
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
                      (minHR ?? "--").toString() + ' Bpm',
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
                      (minHRTime ?? "--").toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: KardioCareAppTheme.dividerPurple,
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
                      (maxHR ?? "--").toString() + ' Bpm',
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
                      (maxHRTime ?? "--").toString(),
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
