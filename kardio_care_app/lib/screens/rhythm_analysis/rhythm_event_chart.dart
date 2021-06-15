import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// To do
// add filter on abnormal normal
// add time on x axis
// format the cards nicer and based on the strings of rhythms passed in

class RhythmEventChart extends StatefulWidget {
  RhythmEventChart(
      {Key key,
      this.lengthRecordingMin,
      this.ekgData,
      this.selectedLead,
      this.numBatches,
      this.allRhythms,
      this.rhythms})
      : super(key: key);

  final List<List<List<double>>> ekgData;
  final List<String> rhythms;
  final int lengthRecordingMin;
  final int selectedLead;
  final int numBatches;
  final bool allRhythms;

  @override
  _RhythmEventChartState createState() => _RhythmEventChartState();
}

class _RhythmEventChartState extends State<RhythmEventChart> {
  int batchIndex;
  int numBatches;
  List<List<List<double>>> ekgData;
  int downSampleAmount;
  int numSamplesToPlot;
  List<int> abnormalRhythmBatchNumbers;
  List<String> currRhythms;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    batchIndex = 0;
    downSampleAmount = 8;
    numSamplesToPlot = (4096 / downSampleAmount).ceil();

    abnormalRhythmBatchNumbers = [];
    for (int i = 0; i < widget.rhythms.length; i++) {
      if (widget.rhythms[i] != 'No Abnormal Rhythm') {
        abnormalRhythmBatchNumbers.add(i);
      }
    }
  }

  var currentPlottingData;

  @override
  Widget build(BuildContext context) {
    if (!widget.allRhythms) {
      numBatches = 2;
      if (batchIndex > numBatches - 1) {
        batchIndex = 0;

        _scrollController.animateTo(0,
            duration: new Duration(milliseconds: 700), curve: Curves.ease);
      }

      ekgData = List.generate(abnormalRhythmBatchNumbers.length,
          (index) => widget.ekgData[abnormalRhythmBatchNumbers[index]]);

      currRhythms = List.generate(abnormalRhythmBatchNumbers.length,
          (index) => widget.rhythms[abnormalRhythmBatchNumbers[index]]);
    } else {
      currRhythms = widget.rhythms;
      numBatches = widget.numBatches;
      ekgData = widget.ekgData;
    }

    currentPlottingData = List.generate(
        numSamplesToPlot,
        (index) => ekgData[batchIndex][index + downSampleAmount - 1]
            [widget.selectedLead]);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.8,
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: _buildCartesianChart(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 100,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: batchIndex == 0
                            ? Colors.grey.shade500
                            : KardioCareAppTheme.actionBlue,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(18)),
                      ),
                      // child: Padding(
                      // padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      // ),
                      onPressed: batchIndex == 0 ? null : lastBatch,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      // width: MediaQuery.of(context).size.width * 0.7,
                      child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: numBatches,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Card(
                                shape: (index == batchIndex)
                                    ? RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                KardioCareAppTheme.actionBlue,
                                            width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(4.0))
                                    : RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                elevation: 6.0,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    // minimumSize:
                                    //     Size.fromWidth(MediaQuery.of(context).size.width),
                                    backgroundColor: KardioCareAppTheme.white,
                                  ),
                                  onPressed: () {
                                    switchBatch(index);
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Container(
                                      //   width:
                                      //       MediaQuery.of(context).size.width *
                                      //           0.38,
                                      //   height: 5,
                                      //   decoration: BoxDecoration(
                                      //       color:
                                      //           KardioCareAppTheme.detailGreen,
                                      //       borderRadius: BorderRadius.all(
                                      //           Radius.circular(1000))),
                                      // ),
                                      // FittedBox(
                                      // fit: BoxFit,

                                      Text(
                                        currRhythms[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: KardioCareAppTheme.detailGray,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Detected",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: KardioCareAppTheme.detailGray,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      // ),
                                      if (index == batchIndex)
                                        currRhythms[index] ==
                                                "No Abnormal Rhythm"
                                            ? Icon(
                                                Icons.check,
                                                color: KardioCareAppTheme
                                                    .detailGreen,
                                                // size: 10,
                                              )
                                            : Icon(
                                                Icons.warning,
                                                color: KardioCareAppTheme
                                                    .detailRed,
                                                // size: 10,
                                              ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 100,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: batchIndex == (numBatches - 1)
                            ? Colors.grey.shade500
                            : KardioCareAppTheme.actionBlue,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(18)),
                      ),
                      // child: Padding(
                      // padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                      // ),
                      onPressed:
                          batchIndex == (numBatches - 1) ? null : nextBatch,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: LinearPercentIndicator(
                alignment: MainAxisAlignment.center,
                width: MediaQuery.of(context).size.width * 0.9,
                lineHeight: 5.0,
                percent: (((widget.allRhythms
                                        ? batchIndex
                                        : abnormalRhythmBatchNumbers[
                                            batchIndex]) +
                                    1) *
                                numSamplesToPlot ??
                            0.0)
                        .toDouble() /
                    (widget.numBatches.toDouble() * numSamplesToPlot),
                progressColor: KardioCareAppTheme.dividerPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Calls while performing the swipe operation
  void performSwipe(ChartSwipeDirection direction) {
    if (direction == ChartSwipeDirection.end) {
      nextBatch();
    } else {
      lastBatch();
    }
  }

  void nextBatch() {
    int index = batchIndex;
    if (batchIndex != (numBatches - 1)) {
      index = batchIndex + 1;
    }

    switchBatch(index);
  }

  void lastBatch() {
    int index = batchIndex;
    if (batchIndex != 0) {
      index = batchIndex - 1;
    }
    switchBatch(index);
  }

  void switchBatch(int index) {
    setState(() {
      batchIndex = index;
    });

    double _position = index * (MediaQuery.of(context).size.width * 0.5) -
        ((MediaQuery.of(context).size.width * 0.5) - 100) / 2;

    _scrollController.animateTo(_position,
        duration: new Duration(milliseconds: 700), curve: Curves.ease);
  }

  /// Returns the cartesian chart
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      primaryYAxis: NumericAxis(
        interval: 2,
        minimum: 0,
        maximum: 4096,
        isVisible: false,
        anchorRangeToVisiblePoints: true,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.black),
      ),
      primaryXAxis: CategoryAxis(
          // visibleMaximum: _visibleMax,
          // visibleMinimum: _visibleMin,
          // labelPlacement: LabelPlacement.onTicks,
          interval: numSamplesToPlot / 4,
          axisLine: AxisLine(width: 0, color: Colors.black),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: 1)),
      plotAreaBorderWidth: 0,
      series: getSeries(),
      onPlotAreaSwipe: (direction) => performSwipe(direction),
    );
  }

  // Returns the chart series
  List<ChartSeries<double, String>> getSeries() {
    return <ChartSeries<double, String>>[
      FastLineSeries<double, String>(
        dataSource: currentPlottingData,
        // borderColor: KardioCareAppTheme.detailRed,
        // borderWidth: 2,
        color: KardioCareAppTheme.detailRed,
        // dataLabelSettings: DataLabelSettings(
        //   isVisible: true,
        //   labelAlignment: ChartDataLabelAlignment.outer,
        // ),
        xValueMapper: (double sales, int index) {
          int batchIndexAllRhythms = batchIndex;
          if (!widget.allRhythms) {
            batchIndexAllRhythms = abnormalRhythmBatchNumbers[batchIndex];
          }

          return ((index + numSamplesToPlot * batchIndexAllRhythms) /
                  (400 / downSampleAmount))
              .toString();
        },
        yValueMapper: (double sales, _) => sales,
      ),
    ];
  }
}
