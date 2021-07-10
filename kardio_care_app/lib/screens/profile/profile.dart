import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Profile extends StatefulWidget {
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
        actions: userInfoBox.keys.length != 0
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: KardioCareAppTheme.actionBlue,
                    radius: 20,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.edit),
                      color: KardioCareAppTheme.background,
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit_profile',
                            arguments: userInfoBox);
                      },
                    ),
                  ),
                ),
              ]
            : null,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: userInfoBox.keys.length != 0
            ? ValueListenableBuilder<Box<UserInfo>>(
                valueListenable: userInfoBox.listenable(),
                builder: (context, userInfoBox, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(19, 70, 19, 20),
                        child: Center(
                          child: Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: FittedBox(
                              child: Text(
                                userInfoBox.getAt(0).firstName +
                                    ' ' +
                                    userInfoBox.getAt(0).lastName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: KardioCareAppTheme.detailGray,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
                        child: Text(
                          "User Info",
                          style: KardioCareAppTheme.subTitle,
                        ),
                      ),
                      const Divider(
                        color: KardioCareAppTheme.dividerPurple,
                        height: 20,
                        thickness: 1,
                        indent: 19,
                        endIndent: 19,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Age',
                                          style: TextStyle(
                                            color:
                                                KardioCareAppTheme.detailGray,
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        Text(
                                          userInfoBox.getAt(0).age.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: KardioCareAppTheme
                                                  .detailGray),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: KardioCareAppTheme.dividerPurple,
                              height: 20,
                              thickness: 1,
                              indent: 19,
                              endIndent: 19,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Weight',
                                          style: TextStyle(
                                            color:
                                                KardioCareAppTheme.detailGray,
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        Text(
                                          userInfoBox
                                                  .getAt(0)
                                                  .weight
                                                  .toString() +
                                              ' kg',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                KardioCareAppTheme.detailGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: KardioCareAppTheme.dividerPurple,
                              height: 20,
                              thickness: 1,
                              indent: 19,
                              endIndent: 19,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(19, 0, 19, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Height',
                                          style: TextStyle(
                                            color:
                                                KardioCareAppTheme.detailGray,
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        Text(
                                          userInfoBox
                                                  .getAt(0)
                                                  .height
                                                  .toString() +
                                              ' m',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                KardioCareAppTheme.detailGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: KardioCareAppTheme.dividerPurple,
                              height: 20,
                              thickness: 1,
                              indent: 19,
                              endIndent: 19,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
                        child: Text(
                          "About The App",
                          style: KardioCareAppTheme.subTitle,
                        ),
                      ),
                      const Divider(
                        color: KardioCareAppTheme.dividerPurple,
                        height: 20,
                        thickness: 1,
                        indent: 19,
                        endIndent: 19,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(19, 20, 19, 0),
                        child: Text(
                          "Data Reset",
                          style: KardioCareAppTheme.subTitle,
                        ),
                      ),
                      const Divider(
                        color: KardioCareAppTheme.dividerPurple,
                        height: 20,
                        thickness: 1,
                        indent: 19,
                        endIndent: 19,
                      ),
                    ],
                  );
                },
              )
            : Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.8,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: KardioCareAppTheme.actionBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    // child: Padding(
                    // padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'User info not found.',
                          style: TextStyle(
                            color: KardioCareAppTheme.white,
                            fontSize: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.person_off_outlined,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Tap to add user info.',
                          style: TextStyle(
                            color: KardioCareAppTheme.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit_profile',
                              arguments: userInfoBox)
                          .then((value) {
                        setState(() {});
                      });
                    }),
              ),
      ),
    );
  }
}
