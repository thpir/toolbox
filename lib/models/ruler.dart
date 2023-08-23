import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screen_props.dart';

class Ruler {
  late double screenHeight;
  late double screenWidgth;
  late double appBarHeight;
  late double paddingBottom;
  late double paddingTop;
  late double dpiFixed;
  late double pixelRatio;
  late BuildContext ctx;
  late bool mm;
  late bool standardCalibration;
  late double calibrationValue;
  late double dpi;
  static const platform = MethodChannel('thpir/dpi');

  Ruler(BuildContext context) {
    screenHeight = ScreenProps.getScreenHeight(context);
    screenWidgth = ScreenProps.getScreenWidth(context);
    appBarHeight = ScreenProps.getAppBarHeight();
    paddingBottom = ScreenProps.getPaddingBottom(context);
    paddingTop = ScreenProps.getPaddingTop(context);
    dpiFixed = ScreenProps.dpiFixed;
    pixelRatio = ScreenProps.getPixelRatio(context);
    ctx = context;
    
  }

  /// This method will use platform specific code to try to retrieve the phone's
  /// DPI from the Android OS. Normally every android phone should allow the app
  /// to access this. In case it doesn't work for some reason, we will use a
  /// default value and notify the user to advice him to calibrate the ruler.
  Future<void> getPhoneDpi() async {
    try {
      final double result = await platform.invokeMethod('getPhoneDpi');
      dpi = result;
    } on PlatformException catch (_) {
      dpi = 160;
    } catch (_) {
      dpi = 160;
    }
  }

  double getPixelCountInMm() {
    if (standardCalibration) {
      return dpiFixed / pixelRatio / 25.4;
    } else {
      return calibrationValue;
    }
  }

  double getPixelCountInInches() {
    if (standardCalibration) {
      return dpiFixed / pixelRatio / 8;
    } else {
      return calibrationValue * 25.4 / 8;
    }
  }

  int getNumberOfVerticalRulerPins(BuildContext context) {
    return mm
        ? ((screenHeight - appBarHeight - paddingBottom - paddingTop) /
                getPixelCountInMm())
            .floor()
        : ((screenHeight - appBarHeight - paddingBottom - paddingTop) /
                getPixelCountInInches())
            .floor();
  }

  /// rulerPinWidth method returns the size of the ruler pin. If the ruler pin is a
  /// full cm/inch that pin will have to be larger that a ruler pin indicating
  /// a value in between two centimeters/inches
  double rulerPinWidth(int index) {
    if (mm) {
      if (index < 9) {
        return 0;
      } else if ((index + 1) % 10 == 0) {
        return getPixelCountInMm() * 6;
      } else {
        return getPixelCountInMm() * 3;
      }
    } else {
      if (index < 3) {
        return 0;
      } else if ((index + 1) % 8 == 0) {
        return (getPixelCountInMm() * 8 / 25.4) * 6;
      } else if ((index + 1) % 2 == 0) {
        return (getPixelCountInMm() * 8 / 25.4) * 4.5;
      } else {
        return (getPixelCountInMm() * 8 / 25.4) * 3;
      }
    }
  }

  /// This method returns a list of ruler pins that are rendered across the
  /// vertical axis of the phone screen
  List<Container> verticalRulerPin(int count) {
    return List.generate(count, (index) {
      return Container(
        height: index == 0 ? getPixelCountInMm() + 1 : getPixelCountInMm(),
        width: rulerPinWidth(index),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(ctx).focusColor,
            ),
          ),
        ),
      );
    }).toList();
  }

  /// This method returns a list of digits that acompany the ruler pins
  ///rendered along the vertical axis of the phone
  List<SizedBox> verticalRulerDigits(int count) {
    return List.generate(count, (index) {
      return SizedBox(
        height: mm
            ? (index == 0 ? getPixelCountInMm() * 12 : getPixelCountInMm() * 10)
            : (index == 0
                ? getPixelCountInMm() * 8.6
                : getPixelCountInMm() * 8),
        child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              mm
                  ? (index > 0 ? (index + 1).toString() : '')
                  : (index + 1).toString(),
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(ctx).focusColor,
              ),
            )),
      );
    }).toList();
  }
}
