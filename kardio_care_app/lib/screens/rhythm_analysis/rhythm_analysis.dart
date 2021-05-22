import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/heart_event_cart.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/heart_rhythm_percents.dart';

class RhythmAnalysis extends StatefulWidget {
  @override
  _RhythmAnalysisState createState() => _RhythmAnalysisState();
}

class _RhythmAnalysisState extends State<RhythmAnalysis> {
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
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 0),
              child: HeartRhythmPercents(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: Text(
                "Abnormal Events",
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
              padding: const EdgeInsets.fromLTRB(9.5, 0, 9.5, 0),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return HeartEventCard(context: context, index: index);
                },
              ),
            ),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: KardioCareAppTheme.actionBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23)),
                ),
                // child: Padding(
                // padding: const EdgeInsets.all(8.0),
                child: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                // ),
                onPressed: () {
                  Navigator.pushNamed(context, '/all_recordings');
                },
              ),
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
