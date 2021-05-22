import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class RecordingCard extends StatelessWidget {
  const RecordingCard({Key key, this.context, this.index}) : super(key: key);

  final BuildContext context;
  final int index;

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
                            '6:30 am',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
                          '10 minute recording',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, color: Colors.black),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "HRV 63",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: KardioCareAppTheme.detailGray,
                    height: 1,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                ],
              ),
              // ),
              onPressed: () {},
            ),
          ),
          Positioned(
            top: index > 0 ? 0.0 : 40.0,
            bottom: index == 4 ? 35.7 : 0.0,
            left: 33.0,
            child: Container(
                height: double.infinity, width: 3.0, color: Colors.black),
          ),
          Positioned(
            top: 15.0,
            left: 15.0,
            child: Container(
              height: 40.0,
              width: 40.0,
              child: index > 0
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                      child: CustomPaint(
                        painter: TrianglePainter(
                          strokeColor: Colors.black,
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
                          shape: BoxShape.circle, color: Colors.black),
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
      {this.strokeColor = Colors.black,
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
