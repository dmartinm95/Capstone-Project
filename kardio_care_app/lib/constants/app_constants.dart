import 'package:flutter/material.dart';

// const double kDefaultPadding = 20.0;
const String kServiceUUID = "202d3e06-252d-40bd-8dc6-0b7bfe15b99f";
const String kLeadOneCharUUID = "4ccf588c-c839-4ec7-9954-94611cc77895";

const int ekgShortLengthMin = 1;
const int ekgMediumLengthMin = 5;
const int ekgLongLengthMin = 10;

List<String> rhythmLabels = [
  'No Abnormal Rhythm',
  'Sinus Bradycardia',
  'Atrial Fibrillation',
  'Sinus Tachycardia',
  '1st Degree AV Block',
  'Bundle Branch Block',
];

List<Color> rhythmColors = [
  Color(0xFFf72585),
  Color(0xFF7209b7),
  Color(0xFF3f37c9),
  Color(0xFF4cc9f0),
  Color(0xFF480ca8),
  Color(0xFF4895ef),
];
