import 'package:flutter/material.dart';
import 'package:kardio_care_app/util/data_filter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BuildEKGPlot extends StatefulWidget {
  const BuildEKGPlot({Key key, this.dataValue, this.dataFilter})
      : super(key: key);

  final List<int> dataValue;
  final DataFilter dataFilter;

  @override
  _BuildEKGPlotState createState() => _BuildEKGPlotState();
}

class _BuildEKGPlotState extends State<BuildEKGPlot> {
  List<LeadData> dataList = <LeadData>[LeadData(0, 0)];
  ChartSeriesController _chartSeriesController;
  int xIndex = 0;
  int defaultNumberPoints = 1000;

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
        minimum: 0,
        maximum: 4096,
      ),
      series: <ChartSeries>[
        FastLineSeries<LeadData, int>(
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController = controller;
          },
          dataSource: updateDataList(widget.dataValue),
          width: 1.5,
          color: Color(0xFFEA517F),
          xValueMapper: (LeadData leadData, _) => leadData.index,
          yValueMapper: (LeadData leadData, _) => leadData.value,
          animationDuration: 0,
        )
      ],
    );
  }

  List<LeadData> updateDataList(List<int> data) {
    // print("Adding data: $data");

    if (data == null) {
      return <LeadData>[LeadData(xIndex, 0)];
    }

    // int sum = data.fold(0, (sum, b) => sum + b);
    // int average = (sum / data.length).round();

    for (int i = 0; i < data.length; i++) {
      try {
        widget.dataFilter.addDataToBuffer(data[i]);
        if (i % widget.dataFilter.downsampleFactor == 0) {
          if (widget.dataFilter.isBufferFull) {
            dataList.add(LeadData(xIndex, widget.dataFilter.getFilteredData()));
          } else {
            dataList.add(LeadData(xIndex, data[i]));
          }
          xIndex = xIndex + 1;
        }
      } catch (e) {
        print("Error observed while updating DataList: ${e.toString()}");
      }

      if (dataList.length ==
          defaultNumberPoints / widget.dataFilter.downsampleFactor) {
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

    return dataList;
  }
}

class LeadData {
  LeadData(this.index, this.value);
  final int index;
  final int value;
}
