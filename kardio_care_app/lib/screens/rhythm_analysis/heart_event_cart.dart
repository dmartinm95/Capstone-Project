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
                width: 8,
                height: 55,
                decoration: BoxDecoration(
                    color: KardioCareAppTheme.detailGreen,
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

                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                          child: Icon(
                            Icons.chevron_right,
                            color: KardioCareAppTheme.detailGray,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'HR 190 bpm',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
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

                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 5, 8),
                          child: Text(
                            '7pm - 2021/02/10',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: KardioCareAppTheme.detailGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
        Navigator.pushNamed(context, '/view_rhythm_event');
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor =  KardioCareAppTheme.detailGray,
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
