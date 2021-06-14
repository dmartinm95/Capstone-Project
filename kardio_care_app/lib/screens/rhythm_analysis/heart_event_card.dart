import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:kardio_care_app/util/data_storage.dart';

class HeartEventCard extends StatelessWidget {
  const HeartEventCard({
    Key key,
    this.context,
    this.index,
    this.rhythms,
    this.rhythmColors,
    this.recordingData,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final List<String> rhythms;
  final List<Color> rhythmColors;
  final RecordingData recordingData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            // minimumSize:
            //     Size.fromWidth(MediaQuery.of(context).size.width),
            backgroundColor: KardioCareAppTheme.background,
          ),
          // child: Padding(
          // padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(recordingData.startTime),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: KardioCareAppTheme.detailGray,
                        ),
                      ),
                      // Spacer(),
                      Expanded(
                        child: SizedBox(),
                      ),

                      Icon(
                        Icons.chevron_right,
                        color: KardioCareAppTheme.detailGray,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: Row(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0,
                      // runSpacing: 5.0,
                      children: <Widget>[
                        for (int i = 0; i < rhythms.length; i++)
                          RhythmTag(
                            rhythmName: rhythms[i],
                            rhythmColor: rhythmColors[i],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ),
          onPressed: () {
            Navigator.pushNamed(context, '/view_rhythm_event',
                arguments: recordingData);
          },
        ),
        const Divider(
          color: KardioCareAppTheme.dividerPurple,
          height: 1,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }

}

class RhythmTag extends StatelessWidget {
  const RhythmTag({Key key, this.rhythmName, this.rhythmColor})
      : super(key: key);

  final String rhythmName;

  final Color rhythmColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 8,
            height: 10,
            decoration: BoxDecoration(
                color: rhythmColor,
                borderRadius: BorderRadius.all(Radius.circular(1000))),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            rhythmName,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: KardioCareAppTheme.detailGray,
            ),
          ),
        ],
      ),
    );
  }
}
