import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HeartRateChart extends StatefulWidget {
  const HeartRateChart({Key key, this.dataValue}) : super(key: key);

  final int dataValue;

  @override
  _HeartRateChartState createState() => _HeartRateChartState();
}

class _HeartRateChartState extends State<HeartRateChart> {
  @override
  Widget build(BuildContext context) {
    // final List<SalesData> chartData = [
    //   SalesData(DateTime(2011), 35),
    //   SalesData(DateTime(2012), 28),
    //   SalesData(DateTime(2013), 34),
    //   SalesData(DateTime(2014), 32),
    //   SalesData(DateTime(2015), 40)
    // ];

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        minimum: DateTime(2015, 1, 1, 1),
        maximum: DateTime(2015, 1, 1, 23),
        intervalType: DateTimeIntervalType.hours,
        dateFormat: DateFormat.jm(),
      ),
      // primaryXAxis: CategoryAxis(
      //   majorGridLines: MajorGridLines(width: 0),
      //   labelIntersectAction: AxisLabelIntersectAction.rotate45,
      // ),
      //  primaryYAxis: NumericAxis(
      //                       minimum: 10,
      //                       maximum: 50
      //                   )
      series: <BoxAndWhiskerSeries<SalesData, DateTime>>[
        BoxAndWhiskerSeries<SalesData, DateTime>(
            showMean: false,
            color: Colors.blue,
            borderColor: Colors.blue,
            dataSource: <SalesData>[
              SalesData(DateTime(2015, 1, 1, 2),
                  [22, 22, 23, 25, 25, 25, 26, 27, 27]),
              SalesData(DateTime(2015, 1, 1, 3),
                  [22, 24, 25, 30, 32, 34, 36, 38, 39, 41]),
              SalesData(DateTime(2015, 1, 1, 5),
                  [22, 22, 23, 25, 25, 25, 26, 27, 27]),
              SalesData(DateTime(2015, 1, 1, 10),
                  [22, 22, 23, 25, 25, 25, 26, 27, 34]),

              //...
            ],
            xValueMapper: (SalesData data, _) => data.x,
            yValueMapper: (SalesData data, _) => data.y),
      ],
    );
  }
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y);

  /// X value of the data point
  final DateTime x;

  /// y value of the data point
  final dynamic y;

  // /// color value of the data point
  // final Color? colors;

  // /// Date time value of the data point
  // final DateTime? date;
}
