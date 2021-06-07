import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HeartRateChart extends StatefulWidget {
  const HeartRateChart({Key key, this.heartRateData}) : super(key: key);

  final Map<DateTime, double> heartRateData;

  @override
  _HeartRateChartState createState() => _HeartRateChartState();
}

class _HeartRateChartState extends State<HeartRateChart> {
  @override
  Widget build(BuildContext context) {
    List<PlottingData> chartData;
    if (widget.heartRateData != null) {
      chartData = widget.heartRateData.entries
          .map((entry) => PlottingData(entry.key, entry.value))
          .toList();
    } else {
      chartData = null;
    }

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        // minimum: dayStart,
        // maximum: dayEnd,
        // intervalType: DateTimeIntervalType.hours,
        rangePadding: ChartRangePadding.additional,
        dateFormat: DateFormat.jm(),
      ),
      primaryYAxis: NumericAxis(
        // minimum: 0,
        // maximum: 80,
        interval: 20,
      ),
      series: <ChartSeries>[
        // Renders line chart
        ScatterSeries<PlottingData, DateTime>(
            markerSettings: MarkerSettings(
                shape: DataMarkerType.circle,
                color: Colors.blue,
                borderColor: Colors.white,
                isVisible: true),
            color: Colors.blue,
            dataSource: chartData,
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

