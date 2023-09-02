import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';

import 'controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';
import 'controllers/storage/shared_prefs/shared_prefs_providers/metrics_provider.dart';
import 'controllers/storage/shared_prefs/shared_prefs_providers/calibration_provider.dart';
import 'controllers/storage/databases/database_provider.dart/database_provider.dart';
import 'views/theme/my_themes.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/ruler_home_screen.dart';
import 'views/screens/ruler_calibration_screen.dart';
import 'views/screens/ruler_measurements_list_screen.dart';
import 'views/screens/compass_home_screen.dart';
import 'views/screens/qr_code_home_screen.dart';
import 'views/screens/qr_code_history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UiThemeProvider uiThemeProvider = UiThemeProvider();

  ThemeData themeProvider(String value) {
    if (value == 'dark') {
      return MyThemes.darkTheme;
    } else {
      return MyThemes.lightTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    // set json file directory for languages
    LocalJsonLocalization.delegate.directories = ['lib/views/languages/i18n'];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UiThemeProvider>(
          create: (_) => UiThemeProvider(),
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) => DatabaseProvider(),
        ),
        ChangeNotifierProvider<MetricsProvider>(
          create: (_) => MetricsProvider(),
        ),
        ChangeNotifierProvider<CalibrationProvider>(
          create: (_) => CalibrationProvider(),
        ),
      ],
      child: Consumer<UiThemeProvider>(
        builder: (context, uiMode, _) => MaterialApp(
          title: 'Toolbox',
          theme: themeProvider(uiMode.uiMode),
          darkTheme: uiMode.uiMode == 'ui' ? MyThemes.darkTheme : null,
          localizationsDelegates: [
            // delegate from flutter_localization
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // delegate from localization package.
            LocalJsonLocalization.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            //Locale('es', 'ES'),
            //Locale('nl', 'BE'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (supportedLocales.contains(locale)) {
              return locale;
            }
            // default language
            return const Locale('en', 'US');
          },
          home: const HomeScreen(),
          routes: {
            RulerHomescreen.routeName: (ctx) => const RulerHomescreen(),
            RulerCalibrationScreen.routeName: (ctx) => const RulerCalibrationScreen(),
            RulerMeasurementsListScreen.routeName: (ctx) => const RulerMeasurementsListScreen(),
            CompassHomeScreen.routeName: (ctx) => const CompassHomeScreen(),
            QRCodeHomeScreen.routeName: (ctx) => const QRCodeHomeScreen(),
            QRCodeHistoryScreen.routeName: (ctx) => const QRCodeHistoryScreen(),
          },
        ),
      ),
    );
  }
}
