import 'package:flutter/material.dart';
import 'package:kardio_care_app/app_theme.dart';

// const double kDefaultPadding = 20.0;
const String kServiceUUID = "202d3e06-252d-40bd-8dc6-0b7bfe15b99f";
const String kLeadOneCharUUID = "4ccf588c-c839-4ec7-9954-94611cc77895";

const int ekgShortLengthMin = 1;
const int ekgMediumLengthMin = 5;
const int ekgLongLengthMin = 10;

List<String> rhythmLabels = [
  'No Abnormal Rhythm',
  'Sinus bradycardia',
  'Atrial fibrillation',
  'Sinus tachycardia',
  '1st degree AV block',
  'Bundle branch block',
];

List<Color> rhythmColors = [
  KardioCareAppTheme.detailGreen,
  KardioCareAppTheme.detailPurple,
  KardioCareAppTheme.detailGray,
  KardioCareAppTheme.detailRed,
  Colors.yellow,
  Colors.blue,
];
