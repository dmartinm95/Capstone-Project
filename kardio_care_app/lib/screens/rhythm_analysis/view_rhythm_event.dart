import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/rhythm_event_chart.dart';
import 'package:kardio_care_app/widgets/block_radio_button.dart';
import 'package:kardio_care_app/widgets/recording_stats.dart';

class ViewRhythmEvent extends StatelessWidget {
  const ViewRhythmEvent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Atrial Flutter Event",
          style: KardioCareAppTheme.screenTitleText,
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: KardioCareAppTheme.actionBlue,
            radius: 16,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.close),
              color: KardioCareAppTheme.background,
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: Text(
                "7pm on January 5, 2020",
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
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: SizedBox(height: 400, child: RhythmEventChart()),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: BlockRadioButton(
                buttonLabels: ['I', 'II', 'III', 'V1'],
                circleBorder: true,
                backgroundColor: KardioCareAppTheme.background,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: RecordingStats(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
              child: Text(
                "Tags",
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
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 100),
              child: Center(
                child: Container(
                  height: 100,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: <Widget>[
                      ChipWidget(chipName: 'Morning'),
                      ChipWidget(chipName: 'Afternoon'),
                      ChipWidget(chipName: 'Evening'),
                      ChipWidget(chipName: 'Running'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: KardioCareAppTheme.background,
        height: 70.0,
        child: Column(
          children: [
            const Divider(
              color: KardioCareAppTheme.dividerPurple,
              height: 1,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: KardioCareAppTheme.actionBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  // child: Padding(
                  // padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Generate Report",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.file_download,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                  // ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChipWidget extends StatefulWidget {
  final String chipName;

  ChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _ChipWidgetState createState() => _ChipWidgetState();
}

class _ChipWidgetState extends State<ChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: KardioCareAppTheme.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: KardioCareAppTheme.detailPurple,
    );
  }
}
