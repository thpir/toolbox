import 'package:flutter/material.dart';
import 'package:toolbox/controllers/message_controller.dart';
import 'package:torch_light/torch_light.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../models/app.dart';
import '../../models/screen_props.dart';
import '../widgets/general_widgets/home_drawer.dart';
import '../widgets/general_widgets/list_tile_ui.dart';
import '../../../controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';

class FlashlightHomeScreen extends StatefulWidget {
  static const routeName = '/flashlight-homescreen';
  const FlashlightHomeScreen({super.key});

  @override
  State<FlashlightHomeScreen> createState() => _FlashlightHomeScreenState();
}

class _FlashlightHomeScreenState extends State<FlashlightHomeScreen> {
  bool _flashOn = false;
  bool _isTorchAvailable = false;
  MessageController messageController = MessageController();

  @override
  void initState() {
    isTorchAvailable();
    super.initState();
  }

  @override
  void dispose() {
    torchOff();
    super.dispose();
  }

  Future isTorchAvailable() async {
    try {
      _isTorchAvailable = await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      messageController
          .getErrorSnackbar("No flashlight available at the moment...");
    }
  }

  Future torchOn() async {
    try {
      await TorchLight.enableTorch();
      setState(() {
        _flashOn = true;
      });
    } on Exception catch (_) {
      _isTorchAvailable
          ? messageController.getErrorSnackbar(
              "Something went wrong. I could not enable the flashlight...")
          : messageController
              .getErrorSnackbar("No flashlight available at the moment...");
    }
  }

  Future torchOff() async {
    try {
      await TorchLight.disableTorch();
      setState(() {
        _flashOn = false;
      });
    } on Exception catch (_) {
      _isTorchAvailable
          ? messageController.getErrorSnackbar(
              "Something went wrong. I could not disable the flashlight...")
          : messageController
              .getErrorSnackbar("No flashlight available at the moment...");
    }
  }

  bool _checkUIMode(String uiMode) {
    if (uiMode == 'dark') {
      return true;
    } else if (uiMode == 'light') {
      return false;
    } else {
      final darkMode = ScreenProps.isDarkMode(context);
      if (darkMode) {
        return true;
      } else {
        return false;
      }
    }
  }

  List<Widget> _tabChildren() {
    return [
      Center(
        child: Image.asset(
          _checkUIMode(Provider.of<UiThemeProvider>(context, listen: false).uiMode)
              ? 'assets/images/international_morse_code_dark.png'
              : 'assets/images/international_morse_code.png',
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                _flashOn ? torchOff() : torchOn();
              },
              child: CircleAvatar(
                radius: 50,
                child: Icon(
                  _flashOn ? Icons.flashlight_on : Icons.flashlight_off,
                  size: 64,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(_flashOn ? 'Flashlight On' : 'Flashlight Off',
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ],
        ),
      ),
      Center(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;
    final uiThemeProvider = Provider.of<UiThemeProvider>(context);

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(args.name,
              style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.home)),
          ],
          bottom:
              TabBar(indicatorColor: Theme.of(context).focusColor, tabs: const [
            Tab(
              child: Text(
                'Morse\nChart',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Flashlight',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Morse\nEncoder',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: _tabChildren()),
        drawer: HomeDrawer(
          appName: args.name,
          avatarPath: args.assetPath,
          drawerContent: const [ListTileUi()],
        ),
      ),
    );
  }
}
