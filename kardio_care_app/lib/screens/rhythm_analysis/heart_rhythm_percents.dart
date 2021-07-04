import 'dart:math';
import 'package:hive/hive.dart';
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
    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'All',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: KardioCareAppTheme.detailGray),
                      ),
                      Text(
                        'Rhythms',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: KardioCareAppTheme.detailGray),
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
    List<String> nameSplit = name.split(" ");
    List<Widget> nameTextWidgets = [
      for (String word in nameSplit)
        Text(
          word,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: KardioCareAppTheme.detailGray),
        )
    ];

    return Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 10, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 4.0,
                        children: nameTextWidgets,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 8, 0),
                      height: 8.0,
                      width: 8.0,
                      // color: color,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 5),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            '$frequency%',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: KardioCareAppTheme.detailGray),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: LinearPercentIndicator(
                      // width: ,
                      // width: 50,
                      lineHeight: 10.0,
                      percent: (frequency ?? 0.0).toDouble() / 100.0,
                      progressColor: color,
                    ),
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
