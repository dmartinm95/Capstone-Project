import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/ekg_recording/recording_charts.dart';
import 'package:kardio_care_app/widgets/recording_stats.dart';

class EKGResults extends StatefulWidget {
  EKGResults({Key key}) : super(key: key);

  @override
  _EKGResultsState createState() => _EKGResultsState();
}

class _EKGResultsState extends State<EKGResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Results",
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
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 0),
              child: RecordingCharts(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 10),
              child: RecordingStats(
                avgHRV: 78,
                avgHR: 78,
                avgO2: 96,
                minHR: 51,
                maxHR: 80,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 15, 19, 0),
              child: Text(
                "Tap Relevant Tags",
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
                      FilterChipWidget(chipName: 'Morning'),
                      FilterChipWidget(chipName: 'Afternoon'),
                      FilterChipWidget(chipName: 'Evening'),
                      FilterChipWidget(chipName: 'Running'),
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
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
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        // ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: KardioCareAppTheme.background,

                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 3.0,
                                  color: KardioCareAppTheme.actionBlue),
                              borderRadius: BorderRadius.circular(18)),
                          // shape: BeveledRectangleBorder(),
                        ),
                        // child: Padding(
                        // padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Restart",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: KardioCareAppTheme.actionBlue,
                          ),
                        ),
                        // ),
                        onPressed: () {},
                      ),
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

class FilterChipWidget extends StatefulWidget {
  final String chipName;

  FilterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: KardioCareAppTheme.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w500),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: KardioCareAppTheme.actionBlue,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: KardioCareAppTheme.detailRed,
    );
  }
}
