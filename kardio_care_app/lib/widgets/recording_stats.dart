import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class RecordingStats extends StatelessWidget {
  const RecordingStats({
    Key key,
    this.avgHRV,
    this.avgHR,
    this.avgO2,
    this.minHR,
    this.maxHR,
  }) : super(key: key);

  final int avgHRV;
  final int avgHR;
  final int avgO2;
  final int minHR;
  final int maxHR;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recording Stats',
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
                width: MediaQuery.of(context).size.width / 2 - 27,
                child: Row(
                  children: [
                    Text('Avg HRV'),
                    Expanded(child: SizedBox()),
                    Text(
                      (avgHRV ?? "--").toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 14,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 27,
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
                width: MediaQuery.of(context).size.width / 2 - 27,
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
              SizedBox(
                width: 14,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 27,
                child: Row(
                  children: [
                    Text('Avg O2 %'),
                    Expanded(child: SizedBox()),
                    Text(
                      (avgO2 ?? "--").toString() + ' %',
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
                width: MediaQuery.of(context).size.width / 2 - 27,
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
                width: 14,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 27,
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
            ],
          ),
        ],
      ),
    );
  }
}
