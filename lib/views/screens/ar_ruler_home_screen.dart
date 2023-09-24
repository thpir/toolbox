import 'package:flutter/material.dart';

import '../../models/app.dart';
import '../widgets/general_widgets/home_drawer.dart';
import '../widgets/general_widgets/list_tile_ui.dart';
import '../widgets/general_widgets/list_tile_metrics.dart';

class ArRulerHomeScreen extends StatelessWidget {
  static const routeName = '/ar-ruler-homescreen';
  const ArRulerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;
    return Scaffold(
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
      ),
      body: const Center(),
      drawer: HomeDrawer(
        appName: args.name,
        avatarPath: args.assetPath,
        drawerContent: const [ListTileUi(), ListTileMetrics()],
      ),
    );
  }
}
