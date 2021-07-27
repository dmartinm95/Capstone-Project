// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:scidart/numdart.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:ui' as dart_ui;
import 'package:flutter/services.dart';

import '../../app_theme.dart';

class GeneratePDF extends StatefulWidget {
  GeneratePDF({Key key}) : super(key: key);

  @override
  _GeneratePDFState createState() => _GeneratePDFState();
}

class _GeneratePDFState extends State<GeneratePDF> {
  var dataForPDF;

  final List<GlobalKey<SfCartesianChartState>> chartKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];

  List<Uint8List> chartImages = [Uint8List(0), Uint8List(0), Uint8List(0)];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Box<UserInfo> userInfoBox;

  int downSampleAmount;
  int numSamplesToPlot;
  int avgHRV;
  int avgHR;
  int minHR;
  int maxHR;
  RecordingData recordingData;
  int currBatch;
  double minYValue = 10000;
  double maxYValue = -1;

  @override
  void initState() {
    super.initState();

    // open boxes
    Hive.openBox<UserInfo>('userInfoBox');
    userInfoBox = Hive.box<UserInfo>('userInfoBox');

    downSampleAmount = 4;
    numSamplesToPlot = (4096 / downSampleAmount).ceil();
  }

  @override
  Widget build(BuildContext context) {
    // final Uint8List imageData = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;

    dataForPDF = ModalRoute.of(context).settings.arguments;
    recordingData = dataForPDF['recordingData'];
    currBatch = dataForPDF['currBatch'];
    avgHRV = dataForPDF['avgHRV'];
    avgHR = dataForPDF['avgHR'];
    minHR = dataForPDF['minHR'];
    maxHR = dataForPDF['maxHR'];

    List<double> allLeads = List.generate(
        numSamplesToPlot,
        (index) =>
            recordingData.ekgData[currBatch][index + downSampleAmount - 1][0]);

    allLeads.addAll(List.generate(
        numSamplesToPlot,
        (index) =>
            recordingData.ekgData[currBatch][index + downSampleAmount - 1][1]));

    allLeads.addAll(List.generate(
        numSamplesToPlot,
        (index) =>
            recordingData.ekgData[currBatch][index + downSampleAmount - 1][2]));

    for (int i = 0; i < allLeads.length; i++) {
      double value = allLeads[i];
      if (value > maxYValue) {
        maxYValue = value;
      }
      if (value < minYValue) {
        minYValue = value;
      }
    }

    maxYValue = maxYValue + 1;
    minYValue = minYValue - 1;

    print("min: $minYValue, max: $maxYValue");

    return Scaffold(
      // bottomNavigationBar: BottomAppBar(
      //   color: KardioCareAppTheme.actionBlue,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       TextButton(
      //         child: Text("Share"),
      //         style: ButtonStyle(),
      //         onPressed: () {
      //           print("Pressed share");
      //         },
      //       ),
      //       TextButton(
      //         child: Text("Save"),
      //         onPressed: () {
      //           print("Pressed save");
      //           _saveAsFile(context, PdfPageFormat.a4 );
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      appBar: AppBar(
        title: Text(
          "EKG Report",
          style: KardioCareAppTheme.screenTitleText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          CircleAvatar(
            backgroundColor: KardioCareAppTheme.actionBlue,
            radius: 15,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.close),
              color: KardioCareAppTheme.background,
              onPressed: () {
                print("Pressed X");
                Navigator.maybePop(context);
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                width: 1100,
                height: 100,
                child: _buildCartesianChart(
                    chartKeys[0],
                    List.generate(
                        numSamplesToPlot,
                        (index) => recordingData.ekgData[currBatch]
                            [index + downSampleAmount - 1][0]),
                    currBatch),
              ),
              SizedBox(
                width: 1000,
                height: 100,
                child: _buildCartesianChart(
                    chartKeys[1],
                    List.generate(
                        numSamplesToPlot,
                        (index) => recordingData.ekgData[currBatch]
                            [index + downSampleAmount - 1][1]),
                    currBatch),
              ),
              SizedBox(
                width: 1000,
                height: 100,
                child: _buildCartesianChart(
                    chartKeys[2],
                    List.generate(
                        numSamplesToPlot,
                        (index) => recordingData.ekgData[currBatch]
                            [index + downSampleAmount - 1][2]),
                    currBatch),
              ),
            ],
          ),
          PdfPreview(
            padding: EdgeInsets.only(
              top: 25,
            ),
            scrollViewDecoration: BoxDecoration(
              color: KardioCareAppTheme.background,
            ),
            actions: [
              PdfPreviewAction(
                icon: const Icon(Icons.save),
                onPressed: _saveAsFile,
              )
            ],
            pdfFileName: DateFormat.MMMMEEEEd()
                    .format(recordingData.startTime) +
                '-EKG-Recording-' +
                (userInfoBox.keys.length != 0
                    ? "${userInfoBox.getAt(0).firstName} ${userInfoBox.getAt(0).lastName}"
                    : ""),
            allowSharing: true,
            canChangePageFormat: false,
            allowPrinting: false,
            canDebug: false,
            initialPageFormat: PdfPageFormat.a4,
            build: (format) => _generatePdf(format),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
    );
    // Uint8List imageData = await chartImageData;
    // final ByteData bytes = await rootBundle.load(imageFile);
    // final Uint8List byteList = bytes.buffer.asUint8List();

    List<Uint8List> leadImages = [
      await _readImageData(chartKeys[0]),
      await _readImageData(chartKeys[1]),
      await _readImageData(chartKeys[2])
    ];

    // const PdfColor green = PdfColor.fromInt(0xff9ce5d0);

    // final appLogo = pw.MemoryImage(
    //   File('../../assets/disconnected.png').readAsBytesSync(),
    // );

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "EKG Recording - " +
                    DateFormat.yMMMd().format(recordingData.startTime) +
                    ' at ' +
                    DateFormat.jm().format(recordingData.startTime),
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(thickness: 2),
              pw.Row(children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Patient Information:",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 15,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Recording Information:",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 15,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Text("Name: "),
                        pw.Text(
                          userInfoBox.keys.length != 0
                              ? "${userInfoBox.getAt(0).firstName} ${userInfoBox.getAt(0).lastName}"
                              : " -- ",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.SizedBox(),
                        ),
                      ]),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Text(
                          "Recording length:",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.SizedBox(),
                        ),
                        pw.Text(
                          recordingData.recordingLengthMin == 1
                              ? "${recordingData.recordingLengthMin} minute"
                              : "${recordingData.recordingLengthMin} minutes",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.SizedBox(width: 50),
                      ]),
                    ],
                  ),
                ),
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Text(
                          userInfoBox.keys.length != 0
                              ? "Sex: ${userInfoBox.getAt(0).gender}"
                              : " -- ",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.SizedBox(),
                        ),
                        pw.Text(
                          userInfoBox.keys.length != 0
                              ? "Age: ${userInfoBox.getAt(0).age}"
                              : " -- ",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.SizedBox(width: 50),
                      ]),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Text(
                          "Avg HRV: ",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.SizedBox(),
                        ),
                        pw.Text(
                          "$avgHRV ms",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.SizedBox(width: 50),
                      ]),
                    ],
                  ),
                ),
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Text(
                          userInfoBox.keys.length != 0
                              ? "Weight: ${userInfoBox.getAt(0).weight} kg"
                              : " -- ",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.SizedBox(),
                        ),
                        pw.Text(
                          userInfoBox.keys.length != 0
                              ? "Height: ${userInfoBox.getAt(0).height} cm"
                              : " -- ",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.SizedBox(width: 50),
                      ]),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Text(
                          "Avg HR: ",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.SizedBox(),
                        ),
                        pw.Text(
                          "$avgHR Bpm",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.SizedBox(width: 50),
                      ]),
                    ],
                  ),
                ),
              ]),
              pw.Divider(thickness: 2),
              pw.Text(
                recordingData.rhythms[currBatch] != 'No Abnormal Rhythm'
                    ? "Detected Heart Rhythm: " +
                        recordingData.rhythms[currBatch]
                    : recordingData.rhythms[currBatch] + ' Detected',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(thickness: 2),
              pw.Row(children: [
                // pw.ClipOval(
                //   child: pw.Container(
                //     width: 25,
                //     height: 25,
                //     color: PdfColors.black,
                //     child: pw.Center(
                //       child: pw.Text(
                //         "I",
                //         style: pw.TextStyle(
                //           color: PdfColors.white,
                //           fontSize: 12,
                //           fontWeight: pw.FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                pw.Expanded(
                  child: pw.SizedBox(
                    child: pw.Image(
                      pw.MemoryImage(
                        leadImages[0],
                      ),
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
              ]),
              pw.Row(children: [
                // pw.ClipOval(
                //   child: pw.Container(
                //     width: 25,
                //     height: 25,
                //     color: PdfColors.black,
                //     child: pw.Center(
                //       child: pw.Text(
                //         "II",
                //         style: pw.TextStyle(
                //           color: PdfColors.white,
                //           fontSize: 12,
                //           fontWeight: pw.FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                pw.Expanded(
                  child: pw.SizedBox(
                    child: pw.Image(
                      pw.MemoryImage(
                        leadImages[1],
                      ),
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
              ]),
              pw.Row(children: [
                // pw.ClipOval(
                //   child: pw.Container(
                //     width: 25,
                //     height: 25,
                //     color: PdfColors.black,
                //     child: pw.Center(
                //       child: pw.Text(
                //         "III",
                //         style: pw.TextStyle(
                //           color: PdfColors.white,
                //           fontSize: 12,
                //           fontWeight: pw.FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                pw.Expanded(
                  child: pw.SizedBox(
                    child: pw.Image(
                      pw.MemoryImage(
                        leadImages[2],
                      ),
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
              ]),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text(
                  "10 seconds of the three lead EKG with the identified rhythm",
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text("Attention:",
                  style: pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 15,
                      fontWeight: pw.FontWeight.normal)),
              pw.SizedBox(height: 10),
              pw.Text(
                  "Rhythm analysis may be inaccurate, consult a trained physician to verify results.",
                  style: pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 12,
                      fontWeight: pw.FontWeight.normal)),
              pw.SizedBox(height: 10),
              pw.Text("Comments:",
                  style: pw.TextStyle(
                      color: PdfColors.black,
                      fontSize: 15,
                      fontWeight: pw.FontWeight.normal)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File(appDocPath + '/' + 'document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  Future<Uint8List> _readImageData(
      GlobalKey<SfCartesianChartState> chartKey) async {
    if (chartKey.currentState != null) {
      final dart_ui.Image data =
          await chartKey.currentState.toImage(pixelRatio: 3.0);
      final ByteData bytes =
          await data.toByteData(format: dart_ui.ImageByteFormat.png);
      if (bytes != null) {
        return bytes.buffer
            .asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      } else {
        throw ('Null found when saving chart to image');
      }
    } else {
      throw ('Null found when saving chart to image');
    }
  }

  SfCartesianChart _buildCartesianChart(chartKey, plottingData, currBatch) {
    return SfCartesianChart(
      borderWidth: 0,
      plotAreaBorderWidth: 0,
      key: chartKey,
      // title: ChartTitle(
      //   text: "Lead #",
      //   alignment: ChartAlignment.center,
      //   textStyle: TextStyle(
      //     fontSize: 6,
      //   ),
      // ),

      primaryYAxis: NumericAxis(
        // title: AxisTitle(
        //   alignment: ChartAlignment.center,
        //   text: "Millivolts (mV)",
        //   textStyle: TextStyle(
        //     fontSize: 6,
        //   ),
        // ),

        tickPosition: TickPosition.outside,
        labelStyle: TextStyle(
          fontSize: 4,
          color: Colors.black,
        ),
        minimum: minYValue, //minYRange.floor().toDouble(),
        maximum: maxYValue, //maxYRange.ceil().toDouble(),
        interval: 1,
        majorGridLines: MajorGridLines(
          width: 0.2,
          color: Colors.black,
        ),
        minorGridLines: MinorGridLines(
          width: 0.1,
          color: Colors.black,
        ),
        minorTicksPerInterval: 4,
        placeLabelsNearAxisLine: true,
        // minorGridLines: MinorGridLines(
        //   width: 0.1,
        //   color: Colors.black,
        // ),
        // minorTicksPerInterval: 4,
      ),
      primaryXAxis: NumericAxis(
        // title: AxisTitle(
        //   alignment: ChartAlignment.center,
        //   text: "Seconds (s)",
        //   textStyle: TextStyle(
        //     fontSize: 6,
        //   ),
        // ),

        tickPosition: TickPosition.outside,
        labelStyle: TextStyle(
          fontSize: 4,
          color: Colors.black,
        ),
        minimum: (numSamplesToPlot * currBatch) / (400 / downSampleAmount),
        maximum: (4096 / downSampleAmount + numSamplesToPlot * currBatch) /
            (400 / downSampleAmount),
        interval: 0.8,
        majorGridLines: MajorGridLines(
          width: 0.2,
          color: Colors.black,
        ),
        minorGridLines: MinorGridLines(
          width: 0.1,
          color: Colors.black,
        ),
        minorTicksPerInterval: 4,
      ),
      series: getSeries(plottingData, currBatch),
    );
  }

  // Returns the chart series
  List<ChartSeries<double, double>> getSeries(plottingData, currBatch) {
    return <ChartSeries<double, double>>[
      FastLineSeries<double, double>(
        width: 0.5,
        dataSource: plottingData,
        animationDuration: 0,
        // borderColor: KardioCareAppTheme.detailRed,
        // borderWidth: 2,
        color: KardioCareAppTheme.detailRed,
        // dataLabelSettings: DataLabelSettings(
        //   isVisible: true,
        //   labelAlignment: ChartDataLabelAlignment.outer,
        // ),
        xValueMapper: (double sales, int index) {
          return (index + numSamplesToPlot * currBatch) /
              (400 / downSampleAmount);
        },
        yValueMapper: (double sales, _) => sales,
      ),
    ];
  }
}
