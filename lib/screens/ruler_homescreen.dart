import 'package:flutter/material.dart';

import '../widgets/home_drawer.dart';
import '../widgets/list_tile_ui.dart';
import '../models/app.dart';

class RulerHomescreen extends StatefulWidget {
  static const routeName = '/ruler-homescreen';
  const RulerHomescreen({super.key});

  @override
  State<RulerHomescreen> createState() => _RulerHomescreenState();
}

class _RulerHomescreenState extends State<RulerHomescreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body: const Center(
        child: FlutterLogo(),
      ),
      drawer: HomeDrawer(
        appName: args.name,
        avatarPath: args.assetPath,
        drawerContent: const [ListTileUi()],
      ),
    );
  }
}
