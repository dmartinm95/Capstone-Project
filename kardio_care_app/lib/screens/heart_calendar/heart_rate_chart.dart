import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HeartRateChart extends StatefulWidget {
  const HeartRateChart({Key key, this.heartRateData, this.fromResultsScreen})
      : super(key: key);

  final Map<DateTime, double> heartRateData;
  final bool fromResultsScreen;

  @override
  _HeartRateChartState createState() => _HeartRateChartState();
}

class _HeartRateChartState extends State<HeartRateChart> {
  double minYRange = 10000;
  double maxYRange = -1;

  // Rounds a number up to be multiple of 5
  double roundNumb(double num) {
    int number = num.toInt();
    int rem = number % 5;
    int result = rem >= 5 ? (number - rem + 5) : (number - rem);
    return result.toDouble();
  }

  // Calculates the optimal interval step size based on the range
  double calculateIntervalStepSize(double range, double targetSteps) {
    double tempStep = range / targetSteps;

    double mag = (log(tempStep) / ln10).floorToDouble();
    double magPow = pow(10, mag);

    double magMsd = (tempStep / magPow + 0.5).roundToDouble();

    if (magMsd > 5.0) {
      magMsd = 10.0;
    } else if (magMsd > 2.0) {
      magMsd = 5.0;
    } else if (magMsd > 1.0) {
      magMsd = 2.0;
    }

    return magMsd * magPow;
  }

  void estimateYRangeFromResults() {
    for (int i = 0; i < widget.heartRateData.length; i++) {
      double value = widget.heartRateData.entries.elementAt(i).value;

      if (value > maxYRange) {
        maxYRange = value;
      }
      if (value < minYRange) {
        minYRange = value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<PlottingData> chartData = List.empty(growable: true);
    List<DateTime> dateTimeList = List.empty(growable: true);
    List<double> hrList = List.empty(growable: true);

    DateTime today = DateTime.now();
    String todayMonth = today.month.toString();
    if (today.month < 10) {
      todayMonth = "0$todayMonth";
    }
    String todayString = "${today.year}-$todayMonth-${today.day}";
    today = DateTime.parse(todayString);

    DateTime startDay = today;
    DateTime endDay =
        today.add(Duration(days: 1)).subtract(Duration(milliseconds: 3));

    if (widget.heartRateData != null) {
      if (widget.fromResultsScreen) {
        estimateYRangeFromResults();
        // If we are from the results page, no need to average out the data
        chartData = widget.heartRateData.entries
            .map((entry) => PlottingData(entry.key, entry.value))
            .toList();
      } else {
        // If we are in the heart calendar page, we do average out the data per recording
        double sumHR = 0;
        int index = 0;
        int prevIndex = 0;
        Duration duration;

        // Iterate through all the HRV entries inside the map (this will have data from all recordings for the chosen date)
        for (int i = 0; i < widget.heartRateData.length; i++) {
          // Store the DateTime key and HRV value from each entry in the map
          DateTime key = widget.heartRateData.entries.elementAt(i).key;
          double hr = widget.heartRateData.entries.elementAt(i).value;

          sumHR += hr;
          index++;

          // Check if we reached the end of the list to avoid through an out-of-bounds exception
          if (i <= widget.heartRateData.length - 2) {
            duration = widget.heartRateData.entries
                .elementAt(i + 1)
                .key
                .difference(key);
          } else {
            duration = Duration(seconds: 60);
          }

          // Whenever the difference between DateTime entries is greater than 30 sec we know it will be from a different recording
          if (duration.inSeconds > 30) {
            // Choose the median as the x value and the average of HR values for the y value when plotting
            dateTimeList.add(widget.heartRateData.entries
                .elementAt(prevIndex + (index ~/ 2))
                .key);
            double hrAverage = sumHR / index;
            hrList.add(hrAverage.floorToDouble());
            if (hrAverage > maxYRange) {
              maxYRange = hrAverage;
            }
            if (hrAverage < minYRange) {
              minYRange = hrAverage;
            }
            sumHR = 0;
            prevIndex += index;
            index = 0;
          }
        }

        for (int i = 0; i < dateTimeList.length; i++) {
          chartData.add(PlottingData(dateTimeList[i], hrList[i]));
        }
      }
    } else {
      chartData = null;
    }

    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(
        // borderColor: KardioCareAppTheme.detailRed,
        // borderWidth: 2,
        textStyle: TextStyle(
          fontSize: 12,
        ),
        canShowMarker: false,
        decimalPlaces: 1,
        duration: 3500,
        enable: true,
        color: KardioCareAppTheme.detailGray,
        header: "",
        format: "point.x\npoint.y bpm",
      ),
      primaryXAxis: DateTimeAxis(
        minimum: hrList.length == 1 ? startDay : null,
        maximum: hrList.length == 1 ? endDay : null,
        rangePadding: ChartRangePadding.additional,
        dateFormat: DateFormat.jm(),
      ),
      primaryYAxis: NumericAxis(
        minimum:
            widget.heartRateData.isNotEmpty ? (minYRange.floor() - 5.0) : 0,
        maximum: widget.heartRateData.isNotEmpty
            ? roundNumb(maxYRange.ceil() + 5.0)
            : 0,
        interval: widget.heartRateData.isNotEmpty
            ? calculateIntervalStepSize((maxYRange - minYRange + 10), 5)
            : 1,
      ),
      series: <ChartSeries>[
        // Renders line chart
        LineSeries<PlottingData, DateTime>(
            animationDuration: 0,
            markerSettings: MarkerSettings(
                shape: DataMarkerType.circle,
                color: KardioCareAppTheme.detailRed,
                borderColor: Colors.red.shade100,
                isVisible: true),
            color: Colors.red.shade100,
            dataSource: chartData,
            dashArray: <double>[5, 5],
            xValueMapper: (PlottingData sales, _) => sales.sampleTime,
            yValueMapper: (PlottingData sales, _) => sales.hr)
      ],
    );
  }
}

class PlottingData {
  PlottingData(this.sampleTime, this.hr);
  final DateTime sampleTime;
  final double hr;
}
