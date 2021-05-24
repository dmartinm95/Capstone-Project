import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HRVChart extends StatefulWidget {
  const HRVChart({Key key, this.dataValue}) : super(key: key);

  final int dataValue;

  @override
  _HRVChartState createState() => _HRVChartState();
}

class _HRVChartState extends State<HRVChart> {
  @override
  Widget build(BuildContext context) {
    final List<SalesData> chartData = [
      SalesData(DateTime(2015, 1, 1, 7), 35),
      SalesData(DateTime(2015, 1, 1, 8), 28),
      SalesData(DateTime(2015, 1, 1, 10), 34),
      SalesData(DateTime(2015, 1, 1, 12), 32),
      SalesData(DateTime(2015, 1, 1, 14), 40),
      SalesData(DateTime(2015, 1, 1, 19), 40)
    ];

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        minimum: DateTime(2015, 1, 1, 1),
        maximum: DateTime(2015, 1, 1, 23),
        intervalType: DateTimeIntervalType.hours,
        dateFormat: DateFormat.jm(),
      ),
      primaryYAxis: NumericAxis(minimum: 0, maximum: 80, interval: 20),
      series: <ChartSeries>[
        // Renders line chart
        LineSeries<SalesData, DateTime>(
            markerSettings: MarkerSettings(
                shape: DataMarkerType.circle,
                color: Colors.blue,
                borderColor: Colors.white,
                isVisible: true),
            color: Colors.blue,
            dataSource: chartData,
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales)
      ],
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final DateTime year;
  final double sales;
}
