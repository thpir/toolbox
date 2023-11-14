import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../models/app.dart';
import '../widgets/general_widgets/home_drawer.dart';
import '../widgets/general_widgets/list_tile_ui.dart';
import '../widgets/torch_widgets/morse_chart.dart';
import '../widgets/torch_widgets/morse_encoder.dart';
import '../widgets/torch_widgets/torch_button.dart';

class FlashlightHomeScreen extends StatelessWidget {
  static const routeName = '/flashlight-homescreen';
  const FlashlightHomeScreen({super.key});

  List<Widget> _tabChildren() {
    return [const MorseChart(), const TorchButton(), const MorseEncoder()];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;

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
          bottom: TabBar(indicatorColor: Theme.of(context).focusColor, tabs: [
            Tab(
              child: Text(
                'tab_1'.i18n(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'tab_2'.i18n(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'tab_3'.i18n(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
