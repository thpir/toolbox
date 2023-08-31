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

  static double getPaddingLeft(BuildContext context) {
    return MediaQuery.of(context).padding.left;
  }

  static double getPaddingRight(BuildContext context) {
    return MediaQuery.of(context).padding.right;
  }

  static double getAppBarHeight() {
    return AppBar().preferredSize.height;
  }

  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  static bool isDarkMode(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }
}
