import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/heart_event_card.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/heart_rhythm_percents.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:hive/hive.dart';

import 'package:kardio_care_app/constants/app_constants.dart';

class RhythmAnalysis extends StatefulWidget {
  @override
  _RhythmAnalysisState createState() => _RhythmAnalysisState();
}

class _RhythmAnalysisState extends State<RhythmAnalysis> {
  Box<RecordingData> box;
  ScrollController _scrollController = ScrollController(initialScrollOffset: 0);

  int currRhythmIndex = 1;
  bool anyRecordingsWithRhythm = true;

  List<double> rhythmFreq = [];

  @override
  void initState() {
    super.initState();

    // open boxes
    Hive.openBox<RecordingData>('recordingDataBox');
    box = Hive.box<RecordingData>('recordingDataBox');
  }

  int countOccurrences(List<String> list, String element) {
    if (list == null || list.isEmpty) {
      return 0;
    }

    var foundElements = list.where((e) => e == element);
    return foundElements.length;
  }

  @override
  Widget build(BuildContext context) {
    List<String> combined = [];
    box.values.forEach((element) {
      combined.addAll(element.rhythms.toList());
    });

    rhythmFreq = [];
    for (var i = 0; i < rhythmLabels.length; i++) {
      rhythmFreq.add(countOccurrences(combined, rhythmLabels[i]).toDouble());
    }

    double sum = rhythmFreq.reduce((value, element) => value + element);
    if (sum != 0) {
      for (var i = 0; i < rhythmFreq.length; i++) {
        rhythmFreq[i] = rhythmFreq[i] / sum;
      }
    }

    if (currRhythmIndex != 0) {
      anyRecordingsWithRhythm = rhythmFreq[currRhythmIndex - 1] > 0;
    } else {
      anyRecordingsWithRhythm = box.keys.length != 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rhythm Analysis",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: Text(
                "Heartbeat Rhythm Breakdown",
                style: KardioCareAppTheme.subTitle,
              ),
            ),
            const Divider(
              color: KardioCareAppTheme.dividerPurple,
              height: 20,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
            HeartRhythmPercents(
              changeRhythmCallback: changeRhythmCallback,
              rhythmFreq: rhythmFreq,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: FittedBox(
                child: Text(
                  (currRhythmIndex == 0)
                      ? 'All Rhythms'
                      : 'Recordings With ' +
                          rhythmLabels[currRhythmIndex - 1] +
                          ' Detected',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Divider(
              color: KardioCareAppTheme.dividerPurple,
              height: 0,
              thickness: 1,
              indent: 19,
              endIndent: 19,
            ),
            SizedBox(
              height: 20,
            ),
            anyRecordingsWithRhythm
                ? Expanded(
                    child:
                        // get all recordings
                        Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 3, 0),
                      child: CupertinoScrollbar(
                        isAlwaysShown: true,
                        thickness: 7,
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                          child: ListView.builder(
                            controller: _scrollController,
                            // padding: EdgeInsets.zero,
                            // shrinkWrap: true,
                            primary: false,

                            // physics: NeverScrollableScrollPhysics(),
                            physics: BouncingScrollPhysics(),

                            itemCount: box.keys.length,
                            itemBuilder: (BuildContext context, int index) {
                              // reverse the index
                              index = box.keys.length - index - 1;

                              if (currRhythmIndex != 0) {
                                if (!box.values
                                    .elementAt(index)
                                    .rhythms
                                    .toSet()
                                    .contains(
                                        rhythmLabels[currRhythmIndex - 1])) {
                                  return Container();
                                }
                              }

                              return HeartEventCard(
                                context: context,
                                index: index,
                                rhythms: box.values
                                    .elementAt(index)
                                    .rhythms
                                    .toSet()
                                    .toList(),
                                rhythmColors: getRhythmColors(box.values
                                    .elementAt(index)
                                    .rhythms
                                    .toSet()
                                    .toList()),
                                recordingData: box.values.elementAt(index),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Center(
                      child: Text(
                        currRhythmIndex == 0
                            ? 'No recordings saved.'
                            : 'No recordings with this rhythm.',
                        style: TextStyle(
                            fontSize: 18, color: KardioCareAppTheme.detailGray),
                      ),
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
            )
          ],
        ),
      ),
    );
  }

  void changeRhythmCallback(int newIndex) {
    setState(() {
      currRhythmIndex = newIndex;

      if (newIndex != 0) {
        anyRecordingsWithRhythm = rhythmFreq[newIndex - 1].toInt() != 0;
      }
    });
  }

  List<Color> getRhythmColors(List<String> rhythms) {
    List<Color> res = [];
    for (var rhythm in rhythms) {
      for (var i = 0; i < rhythmLabels.length; i++) {
        if (rhythmLabels[i] == rhythm) {
          res.add(rhythmColors[i]);
          break;
        }
      }
    }
    return res;
  }
}
