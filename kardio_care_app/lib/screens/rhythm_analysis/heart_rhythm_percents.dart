import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:kardio_care_app/app_theme.dart';

class HeartRhythmPercents extends StatefulWidget {
  HeartRhythmPercents({Key key}) : super(key: key);

  @override
  _HeartRhythmPercentsState createState() => _HeartRhythmPercentsState();
}

class _HeartRhythmPercentsState extends State<HeartRhythmPercents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    'Breakdown of Heartbeat Rhythms',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: KardioCareAppTheme.detailGray,
                    ),
                  ),
                ),
              ),
              RhythmRow(
                name: 'Normal',
                frequency: 90,
                color: KardioCareAppTheme.detailPurple,
              ),
              RhythmRow(
                name: 'Tachycardia',
                frequency: 1,
                color: Colors.red,
              ),
              RhythmRow(
                name: 'Bradycardia',
                frequency: 1,
                color: Colors.red,
              ),
              RhythmRow(
                name: 'Atrial Flutter',
                frequency: 50,
                color: KardioCareAppTheme.detailGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RhythmRow extends StatelessWidget {
  const RhythmRow({Key key, this.name, this.frequency, this.color})
      : super(key: key);

  final String name;
  final int frequency;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(8.0),
                height: 10.0,
                width: 10.0,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: KardioCareAppTheme.detailGray),
                ),
              ),
              // Spacer(),
              Expanded(
                child: SizedBox(
                    // width: 100,
                    ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 5, 8),
                child: Text(
                  '$frequency%',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: KardioCareAppTheme.detailGray),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          LinearPercentIndicator(
            // width: ,
            lineHeight: 5.0,
            percent: (frequency ?? 0.0).toDouble() / 100.0,
            progressColor: color,
          ),
        ],
      ),
    );
  }
}
