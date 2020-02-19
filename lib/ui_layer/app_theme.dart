import 'package:flutter/material.dart';

import 'size_config.dart';

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Color(0xFFFFF7EC);
  static const Color subTitleTextColor = Colors.orange;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: darkTextTheme,
  );

  static final TextTheme lightTextTheme = TextTheme(
    subtitle1: _subTitleLight,
//    button: _buttonLight,
  );

  static final TextTheme darkTextTheme = TextTheme(
    subtitle1: _subTitleDark,
//    button: _buttonDark,
  );

  static final TextStyle _subTitleLight = TextStyle(
    color: subTitleTextColor,
    fontSize: 1 * SizeConfig.textMultiplier,
    height: 1.5,
  );

  static final TextStyle _subTitleDark = _subTitleLight.copyWith(color: Colors.white70);
}