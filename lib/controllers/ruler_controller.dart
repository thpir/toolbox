import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

import '../models/screen_props.dart';
import 'storage/databases/database_provider.dart/database_provider.dart';
import 'message_controller.dart';

class RulerController {
  late double screenHeight;
  late double screenWidth;
  late double appBarHeight;
  late double paddingBottom;
  late double paddingTop;
  late double paddingLeft;
  late double paddingRight;
  late double pixelRatio;
  late double sliderHeight;
  late double sliderWidth;
  late BuildContext ctx;
  late bool standardCalibration;
  late double calibrationValue;
  late double dpi;
  late bool mm;
  static const platform = MethodChannel('thpir/dpi');
  MessageController messageHelper = MessageController();

  RulerController(BuildContext context) {
    screenHeight = ScreenProps.getScreenHeight(context);
    screenWidth = ScreenProps.getScreenWidth(context);
    appBarHeight = ScreenProps.getAppBarHeight();
    paddingBottom = ScreenProps.getPaddingBottom(context);
    paddingTop = ScreenProps.getPaddingTop(context);
    paddingLeft = ScreenProps.getPaddingLeft(context);
    paddingRight = ScreenProps.getPaddingRight(context);
    sliderHeight = screenHeight - appBarHeight - paddingBottom - paddingTop;
    sliderWidth = screenWidth - paddingLeft - paddingRight;
    dpi = ScreenProps.dpiFixed;
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
      return dpi / pixelRatio / 25.4;
    } else {
      return calibrationValue;
    }
  }

  double getPixelCountInInches() {
    if (standardCalibration) {
      return dpi / pixelRatio / 8;
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

  int getNumberOfHorizontalRulerPins() {
    return mm
        ? ((screenWidth - paddingLeft - paddingRight) / getPixelCountInMm())
            .floor()
        : ((screenWidth - paddingLeft - paddingRight) / getPixelCountInInches())
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
        return (getPixelCountInInches() * 8 / 25.4) * 6;
      } else if ((index + 1) % 2 == 0) {
        return (getPixelCountInInches() * 8 / 25.4) * 4.5;
      } else {
        return (getPixelCountInInches() * 8 / 25.4) * 3;
      }
    }
  }

  /// This method returns a list of ruler pins that are rendered across the
  /// vertical axis of the phone screen
  List<Container> verticalRulerPin(int count) {
    return List.generate(count, (index) {
      return Container(
        height: index == 0 
        ? mm ? getPixelCountInMm() + 1  : getPixelCountInInches() + 1
        : mm ? getPixelCountInMm() : getPixelCountInInches(),
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

  // This method returns a list of ruler pins that are rendered across the
  //horizontal axis of the phone screen
  List<Container> horizontalRulerPin(int count) {
    return List.generate(count, (index) {
      return Container(
        width: index == 0 
        ? mm ? getPixelCountInMm() + 1 : getPixelCountInInches()
        : mm? getPixelCountInMm() : getPixelCountInInches(),
        height: rulerPinWidth(index),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1, color: Theme.of(ctx).focusColor),
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
            ? (index == 0 
                ? getPixelCountInMm() * 12
                : getPixelCountInMm() * 10
              )
            : (index == 0
                ? getPixelCountInInches() * 8.6
                : getPixelCountInInches() * 8),
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

  // This method returns a list of digits that acompany the ruler pins
  //rendered along the vertical axis of the phone
  List<SizedBox> horizontalRulerDigits(int count) {
    return List.generate(count, (index) {
      return SizedBox(
        width: mm
            ? (index == 0 
                ? getPixelCountInMm() * 12 
                : getPixelCountInMm() * 10)
            : (index == 0
                ? getPixelCountInInches() * 8.4
                : getPixelCountInInches() * 8),
        child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: mm
                  ? (index < 9
                      ? const EdgeInsets.only(right: 4.0)
                      : const EdgeInsets.only(right: 0.0))
                  : const EdgeInsets.only(right: 0.0),
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(ctx).focusColor,
                ),
              ),
            )),
      );
    }).toList();
  }

  // Save measured value to the database.
  void saveMeasurement(String savedValue, BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE, MMMM d, y');
    String formattedDate = formatter.format(now);
    Provider.of<DatabaseProvider>(context, listen: false)
        .addMeasurement(savedValue, formattedDate);
    ScaffoldMessenger.of(context).showSnackBar(messageHelper
        .getInformationalSnackbar('confirm_message_saved'.i18n(), context));
  }
}
