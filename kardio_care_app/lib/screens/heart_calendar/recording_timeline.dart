import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/heart_calendar/recording_card.dart';

class RecordingTimeline extends StatelessWidget {
  const RecordingTimeline({Key key, this.todaysData}) : super(key: key);

  final List<RecordingData> todaysData;

  @override
  Widget build(BuildContext context) {
    if (todaysData.length == 0) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.12,
          color: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "No recordings, start one now",
                      style: TextStyle(
                          color: KardioCareAppTheme.detailGray, fontSize: 19),
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

    List<double> averageHRVs = [];

    for (var item in todaysData) {
      averageHRVs.add(
          item.heartRateVarData.values.toList().reduce((a, b) => a + b) /
              item.heartRateVarData.values.length);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(9.5, 0, 9.5, 0),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        itemCount: todaysData.length,
        itemBuilder: (BuildContext context, int index) {
          return RecordingCard(
            context: context,
            index: index,
            numRecordings: todaysData.length,
            time: todaysData[todaysData.length - index - 1].startTime,
            lengthOfRecording:
                todaysData[todaysData.length - index - 1].recordingLengthMin,
            avgHRV: averageHRVs[todaysData.length - index - 1].toInt(),
            bloodOxData: todaysData[todaysData.length - index - 1].bloodOxData,
            heartRateData:
                todaysData[todaysData.length - index - 1].heartRateData,
            heartRateVarData:
                todaysData[todaysData.length - index - 1].heartRateVarData,
          );
        },
      ),
    );
  }
}
