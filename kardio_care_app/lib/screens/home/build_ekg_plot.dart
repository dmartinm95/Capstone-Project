import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BuildEKGPlot extends StatefulWidget {
  const BuildEKGPlot({
    Key key,
    this.dataValue,
    this.currentLeadIndex,
  }) : super(key: key);

  final List<int> dataValue;
  final int currentLeadIndex;

  @override
  _BuildEKGPlotState createState() => _BuildEKGPlotState();
}

class _BuildEKGPlotState extends State<BuildEKGPlot> {
  List<LeadData> dataList = <LeadData>[LeadData(0, 0)];
  ChartSeriesController _chartSeriesController;
  int xIndex = 0;
  int defaultNumberPoints = 250;

  int index = 0;
  int downsampleFactor = 2;

  int minYRange = 10000;
  int maxYRange = -1;
  double yRangeOffset = 10;

  bool yRangeReady = false;

  int numberPoints = 0;
  int previousLeadIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      enableAxisAnimation: false,
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        minimum: yRangeReady ? minYRange.toDouble() - yRangeOffset : 0,
        maximum: yRangeReady ? maxYRange.toDouble() + yRangeOffset : 4096,
      ),
      series: <ChartSeries>[
        FastLineSeries<LeadData, int>(
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController = controller;
          },
          dataSource: updateDataList(
            widget.dataValue,
            widget.currentLeadIndex,
          ),
          width: 1.5,
          opacity: 1,
          color: KardioCareAppTheme.detailRed,
          xValueMapper: (LeadData leadData, _) => leadData.index,
          yValueMapper: (LeadData leadData, _) => leadData.value,
          animationDuration: 0,
        )
      ],
    );
  }

  List<LeadData> updateDataList(List<int> data, int currentLeadIndex) {
    if (previousLeadIndex != currentLeadIndex) {
      // Recalculating min and max range
      print("Recalculating min and max range");
      previousLeadIndex = currentLeadIndex;
      yRangeReady = false;
      numberPoints = -50;
      minYRange = 10000;
      maxYRange = -1;
    }

    if (data.isEmpty) {
      return <LeadData>[LeadData(xIndex, 0)];
    }

    for (int i = 0; i < data.length; i++) {
      try {
        if (data[i] == 0) continue;

        if (index % downsampleFactor == 0) {
          dataList.add(LeadData(xIndex, data[i]));
          xIndex = xIndex + 1;

          if (!yRangeReady) {
            if (numberPoints > 0) {
              if (data[i] > maxYRange) {
                maxYRange = data[i];
              }
              if (data[i] < minYRange) {
                minYRange = data[i];
              }
            }

            if (numberPoints >= defaultNumberPoints) {
              yRangeReady = true;
              print("Min y range: $minYRange, Max y range: $maxYRange");
            }
            numberPoints++;
          }
          if (dataList.length >= defaultNumberPoints) {
            dataList.removeAt(0);
            _chartSeriesController?.updateDataSource(
              addedDataIndexes: <int>[dataList.length - 1],
              removedDataIndexes: <int>[0],
            );
          } else {
            _chartSeriesController?.updateDataSource(
              addedDataIndexes: <int>[dataList.length - 1],
            );
          }
        }
        index++;
        if (index == 100) {
          index = 0;
        }
      } catch (e) {
        print("Error observed while updating DataList: ${e.toString()}");
      }
    }

    return dataList;
  }
}

class LeadData {
  LeadData(this.index, this.value);
  final int index;
  final int value;
}
