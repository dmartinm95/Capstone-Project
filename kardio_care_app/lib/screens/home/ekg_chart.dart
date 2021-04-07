import 'package:flutter/material.dart';
import 'package:kardio_care_app/constants/app_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kardio_care_app/constants/app_constants.dart';

class EKGChart extends StatefulWidget {
  const EKGChart({
    Key key,
    this.dataValue,
  }) : super(key: key);

  final double dataValue;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<EKGChart> {
  final Duration animDuration = const Duration(milliseconds: 0);

  int touchedIndex; // we can remove if we are not having the touched interaction

  // list of spots that is updated and shifted for plotting
  List<FlSpot> plottingValues = [
    for (double i = 0; i < 150; i += 1) FlSpot(i, 0.0)
  ];

  // some of the layout needs work to be more adaptive to screen size
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: kBackgroundColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'EKG Data',
                    style: TextStyle(
                        color: const Color(0xff0f4a3c),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: LineChart(
                        plotData(widget.dataValue),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData plotData(double dataValue) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.black.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: false,
      ),
      borderData: FlBorderData(
        show: true,
      ),
      gridData: FlGridData(
        drawVerticalLine: true,
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: false,
          interval: 1,
          reservedSize: 100,
          // : const TextStyle(
          //   color: Color(0xff72719b),
          //   fontWeight: FontWeight.bold,
          //   fontSize: 16,
          // ),
          margin: 10,
          // getTitles: (value) {
          //   return getTitles(value);
          // },
        ),
        leftTitles: SideTitles(showTitles: false, interval: 1),
      ),
      minX: 0,
      maxX: plottingValues.length.toDouble(),
      maxY: 1400,
      minY: 700,
      lineBarsData: linesBarDataMain(dataValue),
    );
  }

  List<LineChartBarData> linesBarDataMain(double dataValue) {
    LineChartBarData updatedLineData = LineChartBarData(
      spots: updatePlottingValues(dataValue),
      isCurved: true,
      colors: [kEKGLineColor, kEKGLineColor],
      curveSmoothness: 0,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );

    return [
      updatedLineData,
    ];
  }

  // function to shift a list by the argument amount
  List<Object> leftShift(List<Object> list, int shiftAmount) {
    if (list == null || list.isEmpty) return list;
    var i = shiftAmount % list.length;
    return list.sublist(i)..addAll(list.sublist(0, i));
  }

  // update the plotting values with the argument dataValue
  List<FlSpot> updatePlottingValues(double dataValue) {
    // shift the plotting values left by one
    plottingValues = leftShift(plottingValues, 1);

    // adjust the x values to match for shift
    for (var i = 0; i < plottingValues.length; i++) {
      plottingValues[i] =
          plottingValues[i].copyWith(x: plottingValues[i].x - 1);
    }

    // update the last plot point with the data from the bluetooth
    plottingValues.last = FlSpot(plottingValues.length.toDouble(), dataValue);

    return plottingValues;
  }
}
