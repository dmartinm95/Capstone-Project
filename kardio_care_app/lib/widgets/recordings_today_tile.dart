import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecordingsTile extends StatefulWidget {
  RecordingsTile({Key key, this.recordingData}) : super(key: key);

  final Box<RecordingData> recordingData;

  @override
  _RecordingsTileState createState() => _RecordingsTileState();
}

class _RecordingsTileState extends State<RecordingsTile> {
  @override
  Widget build(BuildContext context) {
    List<String> dateSplit =
        DateFormat("MMMMEEEEd").format(DateTime.now()).split(",");
    List<Text> dateTextWidgets = [
      for (String word in dateSplit)
        Text(
          word,
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              color: KardioCareAppTheme.detailGray),
        )
    ];
    return Container(
      child: ValueListenableBuilder<Box<RecordingData>>(
        valueListenable: widget.recordingData.listenable(),
        builder: (context, box, _) {
          int numRecordToday = getDataToday(DateTime.now()).length;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(dateTextWidgets[0].data,
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 20)),
              Text(dateTextWidgets[1].data,
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 20)),
              SizedBox(
                height: 10,
              ),
              Text(
                (numRecordToday ?? "--").toString(),
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 40),
              ),
              SizedBox(
                height: 5,
              ),
              numRecordToday == 1
                  ? Text(
                      ' Recording',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    )
                  : Text(
                      ' Recordings',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
              SizedBox(
                height: 50,
              ),
            ],
          );
        },
      ),
    );
  }

  List<RecordingData> getDataToday(DateTime day) {
    Box<RecordingData> box = Hive.box<RecordingData>('recordingDataBox');

    List<RecordingData> todaysData = [];
    for (var item in box.values) {
      if (item.startTime.year == day.year &&
          item.startTime.month == day.month &&
          item.startTime.day == day.day) {
        todaysData.add(item);
      }
    }

    return todaysData;
  }
}
