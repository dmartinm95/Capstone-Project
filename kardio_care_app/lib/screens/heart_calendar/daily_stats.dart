import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';



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