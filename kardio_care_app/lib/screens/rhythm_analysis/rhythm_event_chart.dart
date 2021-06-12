import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RhythmEventChart extends StatefulWidget {
  RhythmEventChart({Key key, this.lengthRecordingMin, this.ekgData})
      : super(key: key);

  final List<List<double>> ekgData;
  final int lengthRecordingMin;

  @override
  _RhythmEventChartState createState() => _RhythmEventChartState();
}

class _RhythmEventChartState extends State<RhythmEventChart> {
  int segmentedControlGroupValue = 0;

  int numSamplesToPlot = 512;

  double _visibleMin = 0;
  double _visibleMax = 512;

  int numBatches;

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    numBatches = 6;

    // ((lengthRecordingMin * 60 * 400) / 2048).ceil();

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: _buildCartesianChart(),
              ),
            ),
            Container(
              height: 100,
              child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: numBatches,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 100,
                      child: Card(
                        elevation: 6.0,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            // minimumSize:
                            //     Size.fromWidth(MediaQuery.of(context).size.width),
                            backgroundColor: KardioCareAppTheme.background,
                          ),
                          onPressed: () {
                            setGroupValues(index);

                            _scrollController.animateTo(
                                index.toDouble() * 100 -
                                    (MediaQuery.of(context).size.width *
                                        0.80 /
                                        2),
                                duration: new Duration(milliseconds: 1000),
                                curve: Curves.ease);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Normal\nRhythm',
                                style: TextStyle(
                                  color: KardioCareAppTheme.detailGray,
                                ),
                              ),
                              if (index == segmentedControlGroupValue)
                                Icon(
                                  Icons.check,
                                  color: KardioCareAppTheme.actionBlue,
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              // alignment: Alignment.center,
              child: Slider(
                activeColor: KardioCareAppTheme.actionBlue,
                divisions: numBatches - 1,
                min: 0,
                max: numBatches.toDouble() - 1,
                onChanged: (double i) {
                  setGroupValues(i.toInt());

                  _scrollController.animateTo(
                      i * 100 - (MediaQuery.of(context).size.width * 0.80 / 2),
                      duration: new Duration(milliseconds: 1000),
                      curve: Curves.ease);
                },
                value: segmentedControlGroupValue.toDouble(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calls while performing the swipe operation
  void performSwipe(ChartSwipeDirection direction) {
    int index;

    if (direction == ChartSwipeDirection.end) {
      if (segmentedControlGroupValue != (numBatches - 1)) {
        index = segmentedControlGroupValue + 1;
      }

      setGroupValues(index);
    } else {
      if (segmentedControlGroupValue != 0) {
        index = segmentedControlGroupValue - 1;
      }
      setGroupValues(index);
    }

    _scrollController.animateTo(
        (index ?? segmentedControlGroupValue) * 100 -
            (MediaQuery.of(context).size.width * 0.80 / 2),
        duration: new Duration(milliseconds: 1000),
        curve: Curves.ease);
  }

  void setGroupValues(int index) {
    setState(() {
      _visibleMin = (index * numSamplesToPlot).toDouble();
      _visibleMax =
          (index * numSamplesToPlot + numSamplesToPlot - 1).toDouble();
      segmentedControlGroupValue = index;
    });
  }

  /// Returns the cartesian chart
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      // axisLabelFormatter: (AxisLabelRenderDetails details) {
      //   if (details.orientation == AxisOrientation.horizontal) {
      //     for (final ChartSampleData sampleData in chartData) {
      //       if (sampleData.xValue == details.actualText) {
      //         return ChartAxisLabel(sampleData.x, details.textStyle);
      //       }
      //     }
      //   }
      //   return ChartAxisLabel(details.text, details.textStyle);
      // },
      primaryYAxis: NumericAxis(
        interval: 2,
        // minimum: 0,
        // maximum: 600,
        isVisible: false,
        anchorRangeToVisiblePoints: true,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.black),
      ),
      primaryXAxis: CategoryAxis(
          visibleMaximum: _visibleMax,
          visibleMinimum: _visibleMin,
          // labelPlacement: LabelPlacement.onTicks,
          interval: numSamplesToPlot / 8,
          axisLine: AxisLine(width: 0, color: Colors.black),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: 1)),
      plotAreaBorderWidth: 0,
      series: getSeries(),
      onPlotAreaSwipe: (direction) => performSwipe(direction),
    );
  }

  /// Returns the chart series
  List<ChartSeries<ChartSampleData, String>> getSeries() {
    List<ChartSampleData> test = [];
    int k = 0;
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 512; j++) {
        test.add(
            ChartSampleData(k.toString(), k.toString(), widget.ekgData[i][j]));
        k++;
      }
    }
    List<ChartSampleData> ekgChartData = test;

    return <ChartSeries<ChartSampleData, String>>[
      SplineAreaSeries<ChartSampleData, String>(
        dataSource: ekgChartData,
        borderColor: KardioCareAppTheme.detailRed,
        borderWidth: 2,
        color: Colors.transparent,
        // dataLabelSettings: DataLabelSettings(
        //   isVisible: true,
        //   labelAlignment: ChartDataLabelAlignment.outer,
        // ),
        xValueMapper: (ChartSampleData sales, _) => sales.xValue,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }
}

class ChartSampleData {
  ChartSampleData(this.xValue, this.x, this.y);
  final String x;
  final String xValue;
  final double y;
}
