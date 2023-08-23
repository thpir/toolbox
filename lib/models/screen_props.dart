import 'package:flutter/material.dart';

class ScreenProps {
  static double dpiFixed = 160;

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getPaddingTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getPaddingBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double getAppBarHeight() {
    return AppBar().preferredSize.height;
  }

  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }
}
