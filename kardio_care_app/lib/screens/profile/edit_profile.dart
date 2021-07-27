import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _fbKey = GlobalKey<FormBuilderState>();
  String genderIndexSelected;
  bool doOnce = true;
  int doOnceCounter = 0;
  Color maleColor = KardioCareAppTheme.detailPurple.withOpacity(0.05);
  Color femaleColor = KardioCareAppTheme.detailPurple.withOpacity(0.05);

  String previousGender = "";

  @override
  void initState() {
    doOnce = true;
    doOnceCounter = 0;
    super.initState();
  }

  void updateColor(String gender) {
    setState(() {
      if (gender == "Male") {
        maleColor = KardioCareAppTheme.detailPurple.withOpacity(0.35);
        femaleColor = KardioCareAppTheme.detailPurple.withOpacity(0.05);
      } else if (gender == "Female") {
        maleColor = KardioCareAppTheme.detailPurple.withOpacity(0.05);
        femaleColor = KardioCareAppTheme.detailPurple.withOpacity(0.35);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Box<UserInfo> userInfoBox = ModalRoute.of(context).settings.arguments;

    Color setGenderSelection(String genderIndex) {
      Color chosenColor;
      setState(() {
        if (userInfoBox.values.length != 0 && doOnce) {
          genderIndexSelected = userInfoBox.getAt(0).gender;
          doOnceCounter++;
          if (doOnceCounter > 1) {
            doOnce = false;
          }

          String storedGenderIndex = userInfoBox.getAt(0).gender;
          print("Gender found in box: $storedGenderIndex");
          if (storedGenderIndex == genderIndex) {
            chosenColor = KardioCareAppTheme.detailPurple.withOpacity(0.35);
          } else {
            chosenColor = KardioCareAppTheme.detailPurple.withOpacity(0.05);
          }
        } else {
          if (genderIndexSelected == genderIndex) {
            chosenColor = KardioCareAppTheme.detailPurple.withOpacity(0.35);
          } else {
            chosenColor = KardioCareAppTheme.detailPurple.withOpacity(0.05);
          }
        }
      });
      return chosenColor;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Edit Profile",
          style: KardioCareAppTheme.screenTitleText,
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: KardioCareAppTheme.actionBlue,
            radius: 15,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.close),
              color: KardioCareAppTheme.background,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: FormBuilder(
        key: _fbKey,
        initialValue: {
          'date': DateTime.now(),
        },
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(19, 15, 19, 0),
                    child: Text(
                      "Edit your personal details",
                      style: KardioCareAppTheme.subTitle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Divider(
                      color: KardioCareAppTheme.dividerPurple,
                      height: 20,
                      thickness: 1,
                      indent: 19,
                      endIndent: 19,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              genderIndexSelected = "Male";
                              updateColor(genderIndexSelected);
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  "Male",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color: KardioCareAppTheme.detailPurple
                                        .withOpacity(0.75),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: KardioCareAppTheme.detailPurple
                                        .withOpacity(0.50),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  color: setGenderSelection("Male"),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Icon(
                                    Icons.male,
                                    color: KardioCareAppTheme.detailPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              genderIndexSelected = "Female";
                              updateColor(genderIndexSelected);
                            });
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  "Female",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color: KardioCareAppTheme.detailPurple
                                        .withOpacity(0.75),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: KardioCareAppTheme.detailPurple
                                        .withOpacity(0.50),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  color: setGenderSelection("Female"),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Icon(
                                    Icons.female,
                                    color: KardioCareAppTheme.detailPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  FormBuilderTextField(
                    initialValue: userInfoBox.values.length != 0
                        ? userInfoBox.getAt(0).firstName
                        : null,
                    name: 'first',
                    keyboardType: TextInputType.name,
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    decoration: getInputDecoration('First Name', null),
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
                    cursorColor: KardioCareAppTheme.actionBlue,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    keyboardType: TextInputType.name,
                    initialValue: userInfoBox.values.length != 0
                        ? userInfoBox.getAt(0).lastName
                        : null,
                    name: 'last',
                    // style: Theme.of(context).textTheme.body1,
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    decoration: getInputDecoration('Last Name', null),
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
                    cursorColor: KardioCareAppTheme.actionBlue,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    initialValue: userInfoBox.values.length != 0
                        ? userInfoBox.getAt(0).age.toString()
                        : null,
                    name: "age",
                    // style: Theme.of(context).textTheme.body1,
                    decoration: getInputDecoration('Age', null),
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
                    cursorColor: KardioCareAppTheme.actionBlue,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.integer(context),
                      FormBuilderValidators.min(context, 18),
                      FormBuilderValidators.max(context, 120),
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    name: "weight",
                    initialValue: userInfoBox.values.length != 0
                        ? userInfoBox.getAt(0).weight.toString()
                        : null,
                    // style: Theme.of(context).textTheme.body1,
                    decoration: getInputDecoration("Weight", "kg"),
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
                    cursorColor: KardioCareAppTheme.actionBlue,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(context),
                      FormBuilderValidators.min(context, 0),
                      FormBuilderValidators.max(context, 300),
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilderTextField(
                    initialValue: userInfoBox.values.length != 0
                        ? userInfoBox.getAt(0).height.toString()
                        : null,
                    name: "height",
                    scrollPadding: const EdgeInsets.fromLTRB(19, 0, 19, 400),
                    // style: Theme.of(context).textTheme.body1,
                    decoration: getInputDecoration("Height", "cm"),
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 20,
                    ),
                    cursorColor: KardioCareAppTheme.actionBlue,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(context),
                      FormBuilderValidators.min(context, 0),
                      FormBuilderValidators.max(context, 300),
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                  SizedBox(
                    height: 75,
                  ),
                ],
              ),
            ),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom)),
      ),
      bottomSheet: Container(
        color: KardioCareAppTheme.background,
        height: 70.0,
        child: Column(
          children: [
            const Divider(
              color: KardioCareAppTheme.dividerPurple,
              height: 1,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: KardioCareAppTheme.actionBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _fbKey.currentState.save();
                    if (_fbKey.currentState.validate()) {
                      print("saving profile info to hive");
                      UserInfo infoToSave;
                      if (userInfoBox.keys.length == 0) {
                        infoToSave = UserInfo();
                      } else {
                        infoToSave = userInfoBox.getAt(0);
                      }

                      infoToSave.firstName = _fbKey.currentState.value['first'];
                      infoToSave.lastName = _fbKey.currentState.value['last'];

                      infoToSave.age =
                          int.parse(_fbKey.currentState.value['age']);

                      infoToSave.weight =
                          double.parse(_fbKey.currentState.value['weight']);

                      infoToSave.height = double.parse(
                        _fbKey.currentState.value['height'],
                      );

                      infoToSave.gender = genderIndexSelected;

                      userInfoBox.put(0, infoToSave);

                      Navigator.of(context).pop();
                      print("user info saved to hive");
                    } else {
                      print("incorrect inputs for profile info");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration getInputDecoration(String labelText, String suffix) {
    return InputDecoration(
      fillColor: KardioCareAppTheme.detailPurple.withOpacity(0.10),
      filled: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none),
      contentPadding: EdgeInsets.all(15),
      labelText: labelText,
      suffixText: suffix,
      suffixStyle: TextStyle(
        height: 1,
        letterSpacing: 2,
        color: KardioCareAppTheme.detailPurple.withOpacity(0.50),
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      labelStyle: TextStyle(
        height: 1,
        letterSpacing: 2,
        color: KardioCareAppTheme.detailPurple.withOpacity(0.50),
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }
}
