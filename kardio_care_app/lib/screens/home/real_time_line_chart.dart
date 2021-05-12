/// Dart imports
import 'dart:async';
import 'dart:math' as math;

/// Package imports
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

/// Renders the realtime line chart sample.
class LiveLineChart extends StatefulWidget {
  /// Creates the realtime line chart sample.
  const LiveLineChart({Key key, this.dataValue}) : super(key: key);

  final double dataValue;

  @override
  _LiveLineChartState createState() => _LiveLineChartState();
}

/// State class of the realtime line chart.
class _LiveLineChartState extends State<LiveLineChart> {
  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(const Duration(milliseconds: 1), _updateDataSource);
  }

  // _LiveLineChartState() {}
  double upCounter = 0;

  Timer timer;
  List<_ChartData> chartData = <_ChartData>[];
  int count = 19;
  ChartSeriesController _chartSeriesController;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLiveLineChart();
  }

  /// Returns the realtime Cartesian line chart.
  SfCartesianChart _buildLiveLineChart() {
    return SfCartesianChart(
        enableAxisAnimation: false,
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(isVisible: false),
        primaryYAxis: NumericAxis(
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0),
            minimum: 0,
            maximum: 1024),
        series: <LineSeries<_ChartData, int>>[
          LineSeries<_ChartData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (_ChartData sales, _) => sales.index,
            yValueMapper: (_ChartData sales, _) => sales.value,
            animationDuration: 0,
          )
        ]);
  }

  List<_ChartData> updateData() {
    chartData.add(_ChartData(count, widget.dataValue));
    if (chartData.length == 250) {
      chartData.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
      );
    }
    count = count + 1;
    return chartData;
  }

  ///Continously updating the data source based on timer
  void updateDataSource() {
    chartData.add(_ChartData(count, widget.dataValue));
    if (chartData.length == 250) {
      chartData.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
      );
    }
    count = count + 1;
  }

  double _updateCounter() {
    upCounter++;
    if (upCounter > 1024) {
      upCounter = 0;
    }
    return upCounter;
  }

  ///Get the random data
  int _getRandomInt(int min, int max) {
    final math.Random _random = math.Random();
    return min + _random.nextInt(max - min);
  }
}

/// Private calss for storing the chart series data points.
class _ChartData {
  _ChartData(this.index, this.value);
  final int index;
  final double value;
}
