import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './providers/ui_theme_provider.dart';
import './theme/my_themes.dart';
import './screens/homescreen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UiThemeProvider>(
          create: (_) => UiThemeProvider(),
        ),
      ],
      child: Consumer<UiThemeProvider>(
        builder: (context, uiMode, _) => MaterialApp(
          title: 'Toolbox',
          theme: themeProvider(uiMode.uiMode),
          darkTheme: uiMode.uiMode == 'ui' ? MyThemes.darkTheme : null,
          home: const HomeScreen(
              title: "Toolbox",   
          ),
        ),
      ),
    );
  }
}
