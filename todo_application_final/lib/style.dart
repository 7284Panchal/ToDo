import 'package:flutter/material.dart';

abstract class Style {
  Color get themeColor;

  Color get headerTextColor;

  Color get titleTextColor;

  Color get subTitleTextColor;

  Color get checkboxBorderColor;

  Color get textWhiteColor;

  Color get textFieldBorderColor;

  Color get hintColor;

  TextStyle get appBarTextStyle;

  TextStyle get headerTextStyle;

  TextStyle get titleTextStyle;

  TextStyle get titleDoneTextStyle;

  TextStyle get subTitleTextStyle;

  TextStyle get textFieldTextStyle;

  TextStyle get buttonTextStyle;
}

class StyleImplementation implements Style {
  @override
  Color get themeColor => Color(0xFF17914A);

  @override
  Color get headerTextColor => Color(0xFF333333);

  @override
  Color get titleTextColor => Color(0xFF4C4C4C);

  @override
  Color get subTitleTextColor => Color(0xFF6E7687);

  @override
  Color get checkboxBorderColor => Color(0xFF637388);

  @override
  Color get textFieldBorderColor => Color(0xFF73859F);

  @override
  Color get hintColor => Color(0xFF6E7687);

  @override
  Color get textWhiteColor => Color(0xFFFFFFFF);

  @override
  TextStyle get appBarTextStyle {
    return TextStyle(
      fontSize: 22,
      color: textWhiteColor,
    );
  }

  @override
  TextStyle get headerTextStyle {
    return TextStyle(
      fontSize: 16,
      color: headerTextColor,
    );
  }

  @override
  TextStyle get titleTextStyle {
    return TextStyle(
      fontSize: 16,
      color: titleTextColor,
    );
  }

  @override
  TextStyle get titleDoneTextStyle {
    return TextStyle(
      fontSize: 16,
      color: titleTextColor,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  TextStyle get subTitleTextStyle {
    return TextStyle(
      fontSize: 14,
      color: subTitleTextColor,
    );
  }

  @override
  TextStyle get textFieldTextStyle {
    return TextStyle(
      color: hintColor,
    );
  }

  @override
  TextStyle get buttonTextStyle {
    return TextStyle(
      fontSize: 16,
      color: textWhiteColor,
    );
  }
}
