import 'dart:math';
import 'package:kardio_care_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:kardio_care_app/app_theme.dart';

class HeartRhythmPercents extends StatefulWidget {
  HeartRhythmPercents({Key key, this.changeRhythmCallback, this.rhythmFreq})
      : super(key: key);

  final Function(int) changeRhythmCallback;
  final List<double> rhythmFreq;

  @override
  _HeartRhythmPercentsState createState() => _HeartRhythmPercentsState();
}

class _HeartRhythmPercentsState extends State<HeartRhythmPercents> {
  int _index = 1;

  PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: PageView.builder(
        itemCount: 7,
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() => _index = index);
          widget.changeRhythmCallback(index);
        },
        itemBuilder: (_, i) {
          if (i == 0) {
            return Transform.scale(
              scale: i == _index ? 1 : 0.9,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            'All Rhythms',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: KardioCareAppTheme.detailGray),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Transform.scale(
            scale: i == _index ? 1 : 0.9,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: RhythmRow(
                name: rhythmLabels[i - 1],
                frequency: (widget.rhythmFreq[i - 1] * 100).ceil(),
                color: rhythmColors[i - 1],
              ),
            ),
          );
        },
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  name,
                  style: TextStyle(
                      // fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: KardioCareAppTheme.detailGray),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              height: 50.0,
              width: 10.0,
              // color: color,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: color),
            ),
          ],
        ),
        Expanded(
          child: Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '$frequency%',
                  style: TextStyle(
                      // fontSize: 30,
                      fontWeight: FontWeight.normal,
                      color: KardioCareAppTheme.detailGray),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: LinearPercentIndicator(
            // width: ,
            // width: 50,
            lineHeight: 10.0,
            percent: (frequency ?? 0.0).toDouble() / 100.0,
            progressColor: color,
          ),
        )
      ],
    ));
  }
}
