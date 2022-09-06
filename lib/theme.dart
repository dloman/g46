import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData kG46Theme = _buildG46Theme();

ThemeData _buildG46Theme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    scaffoldBackgroundColor: kG46GreyLight,
    dialogBackgroundColor: kG46GreyLight,
    backgroundColor: kG46GreyLight,
    brightness: Brightness.light,
    primaryColor: kG46GreyLight,
    accentColor: kG46Red,
  );
}
