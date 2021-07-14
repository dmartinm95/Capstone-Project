import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/data_storage.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Box<UserInfo> userInfoBox;

  @override
  void initState() {
    super.initState();

    // open boxes
    Hive.openBox<UserInfo>('userInfoBox');
    userInfoBox = Hive.box<UserInfo>('userInfoBox');
  }

  Widget textfield({@required String hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 2,
        shadowColor: KardioCareAppTheme.actionBlue.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: KardioCareAppTheme.detailGray,
              fontWeight: FontWeight.w500,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: KardioCareAppTheme.screenTitleText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ValueListenableBuilder<Box<UserInfo>>(
        valueListenable: userInfoBox.listenable(),
        builder: (context, userInfoBox, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.54,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      children: [
                        textfield(
                          hintText: userInfoBox.keys.length != 0
                              ? "Age: ${userInfoBox.getAt(0).age}"
                              : " -- ",
                        ),
                        textfield(
                          hintText: userInfoBox.keys.length != 0
                              ? "Weight: ${userInfoBox.getAt(0).weight} kg"
                              : " -- ",
                        ),
                        textfield(
                          hintText: userInfoBox.keys.length != 0
                              ? "Height: ${userInfoBox.getAt(0).height} cm"
                              : " -- ",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: HeaderCurvedContainer(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: userInfoBox.keys.length != 0
                          ? MediaQuery.of(context).size.height * 0.10
                          : MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: userInfoBox.keys.length != 0
                        ? Text(
                            "${userInfoBox.getAt(0).firstName} ${userInfoBox.getAt(0).lastName}",
                            style: TextStyle(
                              fontSize: 35,
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : _NoProfilePrompt(),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.2,
                child: ElevatedButton(
                  onPressed: () {
                    // print('edit button clicked');
                    Navigator.pushNamed(context, '/edit_profile',
                        arguments: userInfoBox);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(8),
                    primary: Colors.white,
                    elevation: 10,
                    shadowColor: Colors.black,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.black87,
                    size: 30,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.68,
                right: MediaQuery.of(context).size.width * 0.80,
                child: ElevatedButton(
                  onPressed: () {
                    print('About button clicked');
                    // Navigator.pushNamed(context, '/edit_profile',
                    //     arguments: userInfoBox);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(4),
                    primary: Colors.white,
                  ),
                  child: Icon(
                    Icons.info,
                    color: Colors.black87,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.68,
                right: MediaQuery.of(context).size.width * 0.0,
                child: ElevatedButton(
                  onPressed: () {
                    print('Delete button clicked');
                    // Navigator.pushNamed(context, '/edit_profile',
                    //     arguments: userInfoBox);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(4),
                    primary: Colors.white,
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NoProfilePrompt extends StatelessWidget {
  const _NoProfilePrompt({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No profile found",
            style: TextStyle(
              fontSize: 30,
              letterSpacing: 1.5,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Please click the edit button below to create one",
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = KardioCareAppTheme.actionBlue;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
