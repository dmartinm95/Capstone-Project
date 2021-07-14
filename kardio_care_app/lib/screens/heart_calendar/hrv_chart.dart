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

          // Whenever the difference between DateTime entries is greater than 30 sec we know it will be from a different recording
          if (duration.inSeconds > 30) {
            // Choose the median as the x value and the average of HRV values for the y value when plotting
            dateTimeList.add(widget.heartRateVarData.entries
                .elementAt(prevIndex + (index ~/ 2))
                .key);
            double hrvAverage = sumHRV / index;
            hrvList.add(hrvAverage);
            if (hrvAverage > maxYRange) {
              maxYRange = hrvAverage;
            }
            if (hrvAverage < minYRange) {
              minYRange = hrvAverage;
            }
            sumHRV = 0;
            prevIndex += index;
            index = 0;
          }
        }

        for (int i = 0; i < dateTimeList.length; i++) {
          chartData.add(PlottingData(dateTimeList[i], hrvList[i]));
        }
      }
    } else {
      chartData = null;
    }

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        // minimum: dayStart,
        // visibleMinimum: dayStart,
        // maximum: dayEnd,
        // visibleMaximum: dayEnd,
        // intervalType: DateTimeIntervalType.hours,
        rangePadding: ChartRangePadding.additional,
        dateFormat: DateFormat.jm(),
      ),
      primaryYAxis: NumericAxis(
        minimum: widget.heartRateVarData.isNotEmpty ? (minYRange - 5.0) : 0,
        maximum:
            widget.heartRateVarData.isNotEmpty ? roundNumb(maxYRange + 5.0) : 1,
        interval: widget.heartRateVarData.isNotEmpty
            ? calculateIntervalStepSize((maxYRange - minYRange + 10), 5)
            : 1,
      ),
      series: <ChartSeries>[
        // Renders line chart
        LineSeries<PlottingData, DateTime>(
            animationDuration: 0,
            markerSettings: MarkerSettings(
                shape: DataMarkerType.circle,
                color: KardioCareAppTheme.actionBlue,
                borderColor: Colors.blue.shade50,
                isVisible: true),
            color: Colors.blue.shade100,
            dataSource: chartData,
            dashArray: <double>[5, 5],
            xValueMapper: (PlottingData data, _) => data.sampleTime,
            yValueMapper: (PlottingData data, _) => data.hrv)
      ],
    );
  }
}

class PlottingData {
  PlottingData(this.sampleTime, this.hrv);
  final DateTime sampleTime;
  final double hrv;
}
