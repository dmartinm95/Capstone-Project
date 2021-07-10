import 'package:flutter/material.dart';
import 'package:kardio_care_app/util/data_filter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BuildEKGPlot extends StatefulWidget {
  const BuildEKGPlot({
    Key key,
    this.dataValue,
  }) : super(key: key);

  final List<int> dataValue;

  @override
  _BuildEKGPlotState createState() => _BuildEKGPlotState();
}

class _BuildEKGPlotState extends State<BuildEKGPlot> {
  List<LeadData> dataList = <LeadData>[LeadData(0, 0)];
  ChartSeriesController _chartSeriesController;
  int xIndex = 0;
  int defaultNumberPoints = 500;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      enableAxisAnimation: false,
      plotAreaBorderWidth: 0,
      legend: Legend(isVisible: true),
      primaryXAxis: NumericAxis(
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        minimum: 0,
        maximum: 4096,
      ),
      indicators: <TechnicalIndicators<dynamic, dynamic>>[
        EmaIndicator<dynamic, dynamic>(
          seriesName: 'HiloOpenClose',
          valueField: 'high',
        )
      ],
      series: <ChartSeries>[
        FastLineSeries<LeadData, int>(
          name: 'HiloOpenClose',
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController = controller;
          },
          dataSource: updateDataList(widget.dataValue),
          width: 1,
          color: Color(0xFFEA517F),
          xValueMapper: (LeadData leadData, _) => leadData.index,
          yValueMapper: (LeadData leadData, _) => leadData.value,
          animationDuration: 0,
        )
      ],
    );
  }

  List<LeadData> updateDataList(List<int> data) {
    if (data.isEmpty) {
      return <LeadData>[LeadData(xIndex, 0)];
    }

    for (int i = 0; i < data.length; i++) {
      try {
        dataList.add(LeadData(xIndex, data[i]));
        xIndex = xIndex + 1;

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
