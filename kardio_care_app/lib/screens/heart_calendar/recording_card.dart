import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class RecordingCard extends StatelessWidget {
  const RecordingCard(
      {Key key,
      this.context,
      this.index,
      this.numRecordings,
      this.time,
      this.lengthOfRecording,
      this.avgHRV,
      this.bloodOxData,
      this.heartRateData,
      this.heartRateVarData})
      : super(key: key);

  final BuildContext context;
  final int index;
  final int numRecordings;
  final DateTime time;
  final int lengthOfRecording;
  final int avgHRV;
  final Map<DateTime, double> bloodOxData;
  final Map<DateTime, double> heartRateData;
  final Map<DateTime, double> heartRateVarData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: TextButton(
              style: TextButton.styleFrom(
                // minimumSize:
                //     Size.fromWidth(MediaQuery.of(context).size.width),
                backgroundColor: KardioCareAppTheme.background,
                shape: BeveledRectangleBorder(),
              ),
              // child: Padding(
              // padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 70,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            TimeOfDay(hour: time.hour, minute: time.minute)
                                .format(context),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: KardioCareAppTheme.detailGray,
                            ),
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          child: SizedBox(
                              // width: 100,
                              ),
                        ),
                        // SizedBox(
                        //   width: 50,
                        // ),
                        Text(
                          '$lengthOfRecording minute recording',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: KardioCareAppTheme.detailGray,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: KardioCareAppTheme.detailGray,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "HRV $avgHRV",
                          style: TextStyle(
                            fontSize: 16,
                            color: KardioCareAppTheme.detailGray,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: KardioCareAppTheme.dividerPurple,
                    height: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                ],
              ),
              // ),
              onPressed: () {
                Navigator.pushNamed(context, '/view_recording', arguments: {
                  'bloodOxData': bloodOxData,
                  'heartRateData': heartRateData,
                  'heartRateVarData': heartRateVarData,
                  'dateTimeOfRecording': time,
                });
              },
            ),
          ),
          Positioned(
            top: index > 0 ? 0.0 : 40.0,
            bottom: index == (numRecordings - 1) ? 49.0 : 0.0,
            left: 33.0,
            child: Container(
              height: double.infinity,
              width: 3.0,
              color: KardioCareAppTheme.detailGray,
            ),
          ),
          Positioned(
            top: 5.0,
            left: 15.0,
            child: Container(
              height: 40.0,
              width: 40.0,
              child: index > 0
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                      child: CustomPaint(
                        painter: TrianglePainter(
                          strokeColor: KardioCareAppTheme.detailGray,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        // child: Container(
                        //   height: 400,
                        // ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(8.0),
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: KardioCareAppTheme.detailGray,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = KardioCareAppTheme.detailGray,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x, y / 2)
      ..lineTo(0, 0)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
