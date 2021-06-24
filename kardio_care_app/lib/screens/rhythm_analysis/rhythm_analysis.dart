import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/heart_event_card.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/heart_rhythm_percents.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kardio_care_app/widgets/filter_chip_widget.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class RhythmAnalysis extends StatefulWidget {
  @override
  _RhythmAnalysisState createState() => _RhythmAnalysisState();
}

class _RhythmAnalysisState extends State<RhythmAnalysis> {
  Box<RecordingData> box;
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 10);

  int currRhythmIndex = 0;
  bool anyRecordingsWithRhythm = true;

  List<double> rhythmFreq = [];

  @override
  void initState() {
    super.initState();

    // open boxes
    Hive.openBox<RecordingData>('recordingDataBox');
    box = Hive.box<RecordingData>('recordingDataBox');

    // calculate rhythm frequencies
    // rhythmFreq =

    List<String> combined = [];
    box.values.forEach((element) {
      combined.addAll(element.rhythms.toSet().toList());
    });

    for (var i = 0; i < rhythmLabels.length; i++) {
      if (rhythmLabels[i] == 'Bundle branch block') {
        rhythmFreq.add(countOccurrences(combined, 'Right bundle branch block')
                .toDouble() +
            countOccurrences(combined, 'Left bundle branch block').toDouble());
      } else {
        rhythmFreq.add(countOccurrences(combined, rhythmLabels[i]).toDouble());
      }
    }

    double sum = rhythmFreq.reduce((value, element) => value + element);

    for (var i = 0; i < rhythmFreq.length; i++) {
      rhythmFreq[i] = rhythmFreq[i] / sum;
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rhythm Analysis",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
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
            child: Text(
              (currRhythmIndex == 0)
                  ? 'All Rhythms'
                  : 'Recordings With ' + rhythmLabels[currRhythmIndex - 1] + ' Detected',
              style: KardioCareAppTheme.subTitle,
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
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ValueListenableBuilder<Box<RecordingData>>(
                      valueListenable: box.listenable(),
                      builder: (context, box, _) {
                        if (box.keys.length == 0) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              color: Colors.transparent,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "No recordings, start one now",
                                          style: TextStyle(
                                              color:
                                                  KardioCareAppTheme.detailGray,
                                              fontSize: 19),
                                          textAlign: TextAlign.center,
                                        ),
                                        Icon(
                                          Icons.arrow_downward,
                                          color: KardioCareAppTheme.detailGray,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        }

                        // get all recordings
                        return Padding(
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
                                reverse: true,
                                // physics: NeverScrollableScrollPhysics(),
                                physics: BouncingScrollPhysics(),

                                itemCount: box.keys.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (currRhythmIndex != 0) {
                                    if (!box.values
                                        .elementAt(index)
                                        .rhythms
                                        .toSet()
                                        .contains(rhythmLabels[
                                            currRhythmIndex - 1])) {
                                      return null;
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
                        );
                      },
                    ),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Center(
                      child: Text(
                    'No recordings with this rhythm.',
                    style: TextStyle(fontSize: 24),
                  )),
                ),
        ],
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
