import 'package:flutter/material.dart';
import 'package:not_whatsapp/constants/colors.dart';

class FontStyle {
  //H1 Bold

  static TextStyle h1Bold(BuildContext context) {
    return TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: MediaQuery.of(context).size.height * 0.035,
    );
  }

  //H2

  static TextStyle h2(BuildContext context) {
    return TextStyle(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: MediaQuery.of(context).size.height * 0.028,
    );
  }

  //H3

  static TextStyle h3(BuildContext context) {
    return TextStyle(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: MediaQuery.of(context).size.height * 0.02,
    );
  }

  //Lable

  static TextStyle lableStyle() {
    return const TextStyle(
      color: textColor,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 2,
    );
  }

  //Title

  static TextStyle titleStyle() {
    return const TextStyle(
      color: textColor,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      letterSpacing: 1,
    );
  }

  //Sub Title

  static TextStyle subTitleStyle() {
    return TextStyle(
      color: textColor.withOpacity(0.5),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  //Body Text

  static TextStyle bodyText(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * 0.02,
      fontWeight: FontWeight.w500,
      color: textColor.withOpacity(0.8),
    );
  }

  //Message Text

  static TextStyle messageText() {
    return const TextStyle(
      fontSize: 16,
      color: textColor,
    );
  }
}
