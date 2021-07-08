import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
    return Container(
      child: ValueListenableBuilder<Box<RecordingData>>(
        valueListenable: widget.recordingData.listenable(),
        builder: (context, box, _) {
          int numRecordToday = getDataToday(DateTime.now()).length;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat("MMMMEEEEd").format(DateTime.now()),
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (numRecordToday ?? "--").toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                    ),
                  ),
                  numRecordToday == 1
                      ? Text(
                          ' Recording',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 24,
                          ),
                        )
                      : Text(
                          ' Recordings',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 24,
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: 25,
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
