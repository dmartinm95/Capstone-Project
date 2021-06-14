import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/heart_event_cart.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/heart_rhythm_percents.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RhythmAnalysis extends StatefulWidget {
  @override
  _RhythmAnalysisState createState() => _RhythmAnalysisState();
}

class _RhythmAnalysisState extends State<RhythmAnalysis> {
  Box<RecordingData> box;

  @override
  void initState() {
    super.initState();

    // open boxes
    Hive.openBox<RecordingData>('recordingDataBox');
    box = Hive.box<RecordingData>('recordingDataBox');
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: Text(
                "Heartbeat Breakdown",
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
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 0),
              child: HeartRhythmPercents(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: Text(
                "Rhythms From Recordings",
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
            ValueListenableBuilder<Box<RecordingData>>(
              valueListenable: box.listenable(),
              builder: (context, box, _) {
                // get all recordings
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: box.keys.length,
                    itemBuilder: (BuildContext context, int index) {
                      return HeartEventCard(
                        context: context,
                        index: index,
                        rhythms: ['normal', 'Atrial Flutter'],
                        rhythmColors: [
                          KardioCareAppTheme.detailPurple,
                          KardioCareAppTheme.detailGreen
                        ],
                        recordingData: box.values.elementAt(index),
                      );
                    },
                  ),
                );
              },
            ),
            Container(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
