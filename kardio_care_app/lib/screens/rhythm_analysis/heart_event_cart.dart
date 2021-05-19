import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

class HeartEventCard extends StatelessWidget {
  const HeartEventCard({Key key, this.context, this.index}) : super(key: key);

  final BuildContext context;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        // minimumSize:
        //     Size.fromWidth(MediaQuery.of(context).size.width),
        backgroundColor: KardioCareAppTheme.background,
      ),
      // child: Padding(
      // padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 50,
                // height: double.infinity,
                // color: Colors.black,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Atrial Flutter',
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
                          "7pm - 2021/02/10",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
