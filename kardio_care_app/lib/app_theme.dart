import 'package:flutter/material.dart';

// https://www.youtube.com/watch?v=R1GSrrItqUs

// https://material.io/design/typography/the-type-system.html#type-scale
// https://pub.dev/packages/google_fonts

class KardioCareAppTheme {
  // KardioCareAppTheme._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color actionBlue = Color(0xFF4C63D7);

  static const Color detailGreen = Color(0xFF1ACB7F);
  static const Color detailRed = Color(0xFFEA517F);
  static const Color detailPurple = Color(0xFF8472FB);
  static const Color detailGray = Color(0xFF434343);

  static const Color darkText = Color(0xFF434343);
  static const Color darkerText = Color(0xFF434343);
  static const Color lightText = Color(0xFF4A6572);

  static const Color dividerPurple = Color(0x5E8472FB);

  static const String fontName = 'Encode Sans';

  static const TextStyle screenTitleText = TextStyle(
    color: detailGray,
    fontWeight: FontWeight.w700,

    // fontFamily: 'Encode Sans',
    letterSpacing: 1.25,
    wordSpacing: 1.75,
    fontSize: 20,
  );

  static const TextStyle subTitle = TextStyle(
    color: detailGray,
    fontWeight: FontWeight.w600,
    fontFamily: 'Encode Sans',
    fontSize: 17,
  );
}
