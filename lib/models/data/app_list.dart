import 'package:localization/localization.dart';

import '../app.dart';

class AppList {
  List<App> appList = [
    App(name: 'ruler_app'.i18n(), assetPath: 'assets/images/icon_ruler.png', route: '/ruler-homescreen'),
    App(name: 'compass_app'.i18n(), assetPath: 'assets/images/icon_compass.png', route: '/compass-homescreen'),
    App(name: 'qr_code_app'.i18n(), assetPath: 'assets/images/icon_qr_code.png', route: ''),
  ];
}
