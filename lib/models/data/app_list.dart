import 'package:localization/localization.dart';

import '../app.dart';

class AppList {
  List<App> appList = [
    App(name: 'ar_ruler_app'.i18n(), assetPath: 'assets/images/icon_3d_ruler.png', route: '/ar-ruler-homescreen'),
    App(name: 'calculator_app'.i18n(), assetPath: 'assets/images/icon_calculator.png', route: '/calculator-homescreen'),
    App(name: 'compass_app'.i18n(), assetPath: 'assets/images/icon_compass.png', route: '/compass-homescreen'),
    App(name: 'ruler_app'.i18n(), assetPath: 'assets/images/icon_ruler.png', route: '/ruler-homescreen'),
    App(name: 'qr_code_app'.i18n(), assetPath: 'assets/images/icon_qr_code.png', route: '/qr-code-homescreen'),
  ];
}
