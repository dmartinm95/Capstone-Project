import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:scidart/numdart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HRVChart extends StatefulWidget {
  const HRVChart({Key key, this.heartRateVarData, this.fromResultsScreen})
      : super(key: key);
  final Map<DateTime, double> heartRateVarData;
  final bool fromResultsScreen;

  @override
  _HRVChartState createState() => _HRVChartState();
}

class _HRVChartState extends State<HRVChart> {
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
    for (int i = 0; i < widget.heartRateVarData.length; i++) {
      double value = widget.heartRateVarData.entries.elementAt(i).value;
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
    List<double> hrvList = List.empty(growable: true);

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

    if (widget.heartRateVarData != null) {
      if (widget.fromResultsScreen) {
        estimateYRangeFromResults();
        // If we are from the results page, no need to average out the data
        chartData = widget.heartRateVarData.entries
            .map((entry) => PlottingData(entry.key, entry.value))
            .toList();
      } else {
        // If we are in the heart calendar page, we do average out the data per recording
        double sumHRV = 0;
        int index = 0;
        int prevIndex = 0;
        Duration duration;

        // Iterate through all the HRV entries inside the map (this will have data from all recordings for the chosen date)
        for (int i = 0; i < widget.heartRateVarData.length; i++) {
          // Store the DateTime key and HRV value from each entry in the map
          DateTime key = widget.heartRateVarData.entries.elementAt(i).key;
          double hrv = widget.heartRateVarData.entries.elementAt(i).value;

          sumHRV += hrv;
          index++;

          // Check if we reached the end of the list to avoid through an out-of-bounds exception
          if (i <= widget.heartRateVarData.length - 2) {
            duration = widget.heartRateVarData.entries
                .elementAt(i + 1)
                .key
                .difference(key);
          } else {
            duration = Duration(seconds: 60);
          }

          // Whenever the difference between DateTime entries is greater than 5 sec we know it will be from a different recording
          if (duration.inSeconds > 10) {
            // Choose the median as the x value and the average of HRV values for the y value when plotting
            // dateTimeList.add(widget.heartRateVarData.entries
            //     .elementAt(prevIndex + (index ~/ 2))
            //     .key);
            dateTimeList
                .add(widget.heartRateVarData.entries.elementAt(prevIndex).key);
            double hrvAverage = sumHRV / index;
            hrvList.add(hrvAverage);
            if (hrvAverage > maxYRange && hrvAverage != 0) {
              maxYRange = hrvAverage;
            }
            if (hrvAverage < minYRange && hrvAverage != 0) {
              minYRange = hrvAverage;
            }
            sumHRV = 0;
            prevIndex += index;
            index = 0;
          }
        }

        for (int i = 0; i < dateTimeList.length; i++) {
          if (hrvList[i] != 0) {
            // Only add points no-zero values to avoid messing up chart view
            chartData.add(PlottingData(dateTimeList[i], hrvList[i]));
          }
        }
      }
    } else {
      chartData = null;
    }

    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(
        textStyle: TextStyle(
          fontSize: 12,
        ),
        canShowMarker: false,
        decimalPlaces: 1,
        duration: 3500,
        enable: true,
        color: KardioCareAppTheme.detailGray,
        header: "",
        format: "point.x\npoint.y ms",
      ),
      primaryXAxis: DateTimeAxis(
        minimum: hrvList.length == 1 ? startDay : null,
        maximum: hrvList.length == 1 ? endDay : null,
        rangePadding: ChartRangePadding.additional,
        dateFormat: DateFormat.jm(),
      ),
      primaryYAxis: NumericAxis(
          // minimum:
          //     widget.heartRateVarData.isNotEmpty ? (minYRange.floor() - 5.0) : 0,
          // maximum: widget.heartRateVarData.isNotEmpty
          //     ? roundNumb(maxYRange.ceil() + 5.0)
          //     : 1,
          // interval: widget.heartRateVarData.isNotEmpty
          //     ? calculateIntervalStepSize((maxYRange - minYRange + 10), 5)
          //     : 1,
          ),
      series: <ChartSeries>[
        // Renders line chart
        LineSeries<PlottingData, DateTime>(
            animationDuration: 0,
            markerSettings: MarkerSettings(
                shape: DataMarkerType.circle,
                borderWidth: 1,
                color: KardioCareAppTheme.detailRed,
                borderColor: Colors.red.shade100,
                isVisible: true),
            color: widget.fromResultsScreen
                ? Colors.transparent
                : Colors.red.shade100,
            dataSource: chartData,
            dashArray: widget.fromResultsScreen ? null : <double>[5, 5],
            xValueMapper: (PlottingData data, _) => data.sampleTime,
            yValueMapper: (PlottingData data, _) => data.hrv),
      ],
    );
  }
}

class PlottingData {
  PlottingData(this.sampleTime, this.hrv);
  final DateTime sampleTime;
  final double hrv;
}
