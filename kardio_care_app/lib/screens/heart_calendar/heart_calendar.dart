import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/heart_calendar/daily_stats_from_data.dart';
import 'package:kardio_care_app/screens/heart_calendar/daily_stats.dart';
import 'package:kardio_care_app/screens/heart_calendar/recording_card.dart';
import 'package:kardio_care_app/screens/heart_calendar/daily_trend_charts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kardio_care_app/screens/heart_calendar/recording_timeline.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'dart:math';

class HeartCalendar extends StatefulWidget {
  @override
  _HeartCalendarState createState() => _HeartCalendarState();
}

class _HeartCalendarState extends State<HeartCalendar> {
  DateTime selectedDate = DateTime.now();
  double maxHR;
  double minHR;
  String maxHRTimeString;
  String minHRTimeString;
  Box<RecordingData> box;

  bool filterDays(DateTime day) {
    // return true on days with recordings and on the current day
    var keysVals = box.keys;

    DateTime currTime = DateTime.now();

    if (currTime.year == day.year &&
        currTime.month == day.month &&
        currTime.day == day.day) {
      return true;
    }
    if (keysVals.isNotEmpty) {
      for (var item in keysVals) {
        var recordTime = DateTime.parse(item);

        if (recordTime.year == day.year &&
            recordTime.month == day.month &&
            recordTime.day == day.day) {
          return true;
        }
      }
    }

    return false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: selectedDate,
      selectableDayPredicate: filterDays,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: KardioCareAppTheme.actionBlue,
              onPrimary: Colors.white,
              surface: KardioCareAppTheme.white,
              onSurface: KardioCareAppTheme.detailGray,
            ),
            dialogBackgroundColor: KardioCareAppTheme.background,
          ),
          child: child,
        );
      },
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
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
      backgroundColor: KardioCareAppTheme.background,
      appBar: AppBar(
        title: Text(
          "Heart Calendar",
          style: KardioCareAppTheme.screenTitleText,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 40),
          child: Container(
            width: double.infinity,
            color: KardioCareAppTheme.actionBlue,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize:
                          Size.fromWidth(MediaQuery.of(context).size.width),
                      backgroundColor: KardioCareAppTheme.actionBlue,
                      shape: BeveledRectangleBorder(),
                    ),
                    // child: Padding(
                    // padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat("yMMMMEEEEd").format(selectedDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: KardioCareAppTheme.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: KardioCareAppTheme.white,
                        )
                      ],
                    ),
                    // ),
                    onPressed: () => _selectDate(context),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder<Box<RecordingData>>(
          valueListenable: box.listenable(),
          builder: (context, box, _) {
            List<RecordingData> todaysData = getDataToday(selectedDate);

            Map<DateTime, double> combinedHRData = {};
            Map<DateTime, double> combinedHRVData = {};
            Map<DateTime, double> combinedBloodOxData = {};

            for (RecordingData item in todaysData) {
              combinedHRData.addAll(item.heartRateData);
              combinedHRVData.addAll(item.heartRateVarData);
              combinedBloodOxData.addAll(item.bloodOxData);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
                  child: Text(
                    "Trends",
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
                  padding: const EdgeInsets.fromLTRB(19, 10, 19, 10),
                  child: DailyTrendCharts(
                    heartRateData: combinedHRData,
                    heartRateVarData: combinedHRVData,
                  ),
                ),
                DailyStatsFromData(
                  combinedHRData: combinedHRData,
                  combinedBloodOxData: combinedBloodOxData,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(19, 15, 19, 0),
                  child: Text(
                    "Todays Recordings",
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
                RecordingTimeline(
                  todaysData: todaysData,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(19, 10, 19, 10),
                  child: Container(
                    height: 15,
                    color: KardioCareAppTheme.background,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
