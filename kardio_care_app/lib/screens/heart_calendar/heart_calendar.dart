import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/heart_calendar/daily_stats.dart';
import 'package:kardio_care_app/screens/heart_calendar/recording_card.dart';
import 'package:kardio_care_app/screens/heart_calendar/daily_trend_charts.dart';

class HeartCalendar extends StatefulWidget {
  @override
  _HeartCalendarState createState() => _HeartCalendarState();
}

class _HeartCalendarState extends State<HeartCalendar> {
  DateTime selectedDate = DateTime(2020, 1, 14);

  bool _predicate(DateTime day) {
    if ((day.isAfter(DateTime(2020, 1, 5)) &&
        day.isBefore(DateTime(2020, 1, 9)))) {
      return true;
    }

    if ((day.isAfter(DateTime(2020, 1, 10)) &&
        day.isBefore(DateTime(2020, 1, 15)))) {
      return true;
    }
    if ((day.isAfter(DateTime(2020, 2, 5)) &&
        day.isBefore(DateTime(2020, 2, 17)))) {
      return true;
    }

    return false;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: selectedDate,
      selectableDayPredicate: _predicate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2021),
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
        child: Column(
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
              child: DailyTrendCharts(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 15, 19, 15),
              child: DailyStats(),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(9.5, 0, 9.5, 0),
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return RecordingCard(
                    context: context,
                    index: index,
                    numRecordings: 4,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(19, 10, 19, 10),
              child: Container(
                height: 15,
                color: KardioCareAppTheme.background,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
