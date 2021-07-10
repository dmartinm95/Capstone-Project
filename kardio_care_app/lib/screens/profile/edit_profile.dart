import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kardio_care_app/app_theme.dart';
import 'package:kardio_care_app/util/data_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final Box<UserInfo> userInfoBox = ModalRoute.of(context).settings.arguments;

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
            radius: 16,
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(19, 20, 19, 20),
        child: FormBuilder(
          key: _fbKey,
          initialValue: {
            'date': DateTime.now(),
          },
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
              child: Column(
                children: [
                  FormBuilderTextField(
                    initialValue: userInfoBox.values.length != 0
                        ? userInfoBox.getAt(0).firstName
                        : null,
                    name: 'first',
                    keyboardType: TextInputType.name,
                    // style: Theme.of(context).textTheme.body1,
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    // decoration: InputDecoration(labelText: "First Name"),
                    decoration: getInputDecoration('First Name', null),
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
                    decoration: getInputDecoration("Height", "m"),
                    cursorColor: KardioCareAppTheme.actionBlue,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(context),
                      FormBuilderValidators.min(context, 0),
                      FormBuilderValidators.max(context, 120),
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom)),
        ),
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
                  // child: Padding(
                  // padding: const EdgeInsets.all(8.0),
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
                  // ),
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
      focusedBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: KardioCareAppTheme.actionBlue, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: KardioCareAppTheme.detailGray, width: 2.0),
      ),
      fillColor: KardioCareAppTheme.detailPurple,
      // suffixIcon: null,
      contentPadding: EdgeInsets.only(bottom: 3),
      labelText: labelText,
      suffixText: suffix,
      labelStyle: TextStyle(
        color: KardioCareAppTheme.detailGray,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),

      floatingLabelBehavior: FloatingLabelBehavior.always,
      // hintText: placeholder,
      hintStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: KardioCareAppTheme.detailGray,
      ),
    );
  }
}
