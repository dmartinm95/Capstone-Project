import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/screens/rhythm_analysis/rhythm_event_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HRVChart extends StatefulWidget {
  const HRVChart({Key key, this.heartRateVarData}) : super(key: key);
  final Map<DateTime, double> heartRateVarData;

  @override
  _HRVChartState createState() => _HRVChartState();
}

class _HRVChartState extends State<HRVChart> {
  @override
  Widget build(BuildContext context) {
    List<PlottingData> chartData;
    if (widget.heartRateVarData != null) {
      chartData = widget.heartRateVarData.entries
          .map((entry) => PlottingData(entry.key, entry.value))
          .toList();
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
