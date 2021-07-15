// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

import '../../app_theme.dart';

class GeneratePDF extends StatefulWidget {
  GeneratePDF({Key key}) : super(key: key);

  @override
  _GeneratePDFState createState() => _GeneratePDFState();
}

class _GeneratePDFState extends State<GeneratePDF> {
  String title = "PDF state";

  // final GlobalKey<SfCartesianChartState> _chartKey = GlobalKey();

  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // bool pressed = false;

  // Uint8List imageData = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    final Uint8List imageData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Rhythm Event PDF",
            style: KardioCareAppTheme.screenTitleText,
          ),
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
        body: PdfPreview(
          actions: [
            PdfPreviewAction(
              icon: const Icon(Icons.save),
              onPressed: _saveAsFile,
            )
          ],
          canChangeOrientation: false,
          canChangePageFormat: false,
          allowPrinting: false,
          canDebug: false,
          initialPageFormat: PdfPageFormat.a4,
          build: (format) => _generatePdf(format, title, imageData),
        ));
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String title, Uint8List byteList) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    // Uint8List imageData = await chartImageData;
    // final ByteData bytes = await rootBundle.load(imageFile);
    // final Uint8List byteList = bytes.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.Row(children: [
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      // pw.Image(pw.RawImage(bytes: imageData, height: 100, width: 100)),
                      pw.SizedBox(
                        // width: double.infinity,
                        child: pw.FittedBox(
                          child: pw.Text("Patient:",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.normal)),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      // pw.Image(pw.RawImage(bytes: imageData, height: 100, width: 100)),
                      pw.SizedBox(
                        // width: double.infinity,
                        child: pw.FittedBox(
                          child: pw.Text("Disclaimer:",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.normal)),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                    ],
                  ),
                ),
              ]),
              pw.Row(children: [
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      // pw.Image(pw.RawImage(bytes: imageData, height: 100, width: 100)),
                      pw.SizedBox(
                        // width: double.infinity,
                        child: pw.FittedBox(
                          child: pw.Text("Recording Information:",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.normal)),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      // pw.Image(pw.RawImage(bytes: imageData, height: 100, width: 100)),
                      pw.SizedBox(
                        // width: double.infinity,
                        child: pw.FittedBox(
                          child: pw.Text("Comments:",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 15,
                                  fontWeight: pw.FontWeight.normal)),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                    ],
                  ),
                ),
              ]),
              pw.Image(
                  pw.MemoryImage(
                    byteList,
                  ),
                  fit: pw.BoxFit.contain),
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
}
