import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:kardio_care_app/util/data_storage.dart';

class HeartEventCard extends StatelessWidget {
  const HeartEventCard({
    Key key,
    this.context,
    this.index,
    this.rhythms,
    this.rhythmColors,
    this.recordingData,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final List<String> rhythms;
  final List<Color> rhythmColors;
  final RecordingData recordingData;

  @override
  Widget build(BuildContext context) {
    List<Widget> rhythmsColorTags = [];
    print(rhythms);
    rhythms.sort((a, b) => a.toString().compareTo(b.toString()));
    print(rhythms);
    for (int i = 0; i < rhythms.length; i++) {
      rhythmsColorTags.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: rhythmColors[i].withOpacity(0.5),
                    spreadRadius: 0.50,
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  )
                ],
                color: rhythmColors[i],
                borderRadius: BorderRadius.all(Radius.circular(1000))),
          ),
        ),
      );
    }

    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            // minimumSize:
            //     Size.fromWidth(MediaQuery.of(context).size.width),
            backgroundColor: KardioCareAppTheme.background,
          ),
          // child: Padding(
          // padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                // width: MediaQuery.of(context).size.width - 50,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(recordingData.startTime),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: KardioCareAppTheme.detailGray,
                        ),
                      ),
                      // Spacer(),
                      Expanded(
                        child: SizedBox(),
                      ),

                      Icon(
                        Icons.chevron_right,
                        color: KardioCareAppTheme.detailGray,
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text("${rhythms.length} Rhythms",
                        style: TextStyle(color: KardioCareAppTheme.detailGray)),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  ...rhythmsColorTags,
                ],
              )
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.8,
              //   height: 50,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           children: [
              //             rhythmsTags.length >= 1
              //                 ? rhythmsTags[0]
              //                 : Container(),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             rhythmsTags.length >= 2
              //                 ? rhythmsTags[1]
              //                 : Container(),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             rhythmsTags.length >= 3
              //                 ? rhythmsTags[2]
              //                 : Container(),
              //           ],
              //         ),
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           rhythmsTags.length >= 4 ? rhythmsTags[3] : Container(),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           rhythmsTags.length >= 5 ? rhythmsTags[4] : Container(),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           rhythmsTags.length >= 6 ? rhythmsTags[5] : Container(),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),

          // ),
          onPressed: () {
            Navigator.pushNamed(context, '/view_rhythm_event',
                arguments: recordingData);
          },
        ),
        const Divider(
          color: KardioCareAppTheme.dividerPurple,
          height: 1,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }
}

// class RhythmTag extends StatelessWidget {
//   const RhythmTag({Key key, this.rhythmName, this.rhythmColor})
//       : super(key: key);

//   final String rhythmName;

//   final Color rhythmColor;

//   @override
//   Widget build(BuildContext context) {
// return Container(
//   child: Row(
//     children: [
//       Container(
//         width: 8,
//         height: 10,
//         decoration: BoxDecoration(
//             color: rhythmColor,
//             borderRadius: BorderRadius.all(Radius.circular(1000))),
//       ),
//       SizedBox(
//         width: 5,
//       ),
//       Text(
//         rhythmName,
//         style: TextStyle(
//           fontWeight: FontWeight.normal,
//           color: KardioCareAppTheme.detailGray,
//         ),
//       ),
//     ],
//   ),
// );
//   }
// }
