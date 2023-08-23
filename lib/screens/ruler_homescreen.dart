import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/widgets/vertical_ruler.dart';

import '../widgets/home_drawer.dart';
import '../widgets/list_tile_ui.dart';
import '../models/app.dart';
import '../models/ruler.dart';
import '../providers/calibration_provider.dart';
import '../providers/metrics_provider.dart';

class RulerHomescreen extends StatefulWidget {
  static const routeName = '/ruler-homescreen';
  const RulerHomescreen({super.key});

  @override
  State<RulerHomescreen> createState() => _RulerHomescreenState();
}

class _RulerHomescreenState extends State<RulerHomescreen> {
  MetricsProvider metricsProvider = MetricsProvider();
  CalibrationProvider calibrationProvider = CalibrationProvider();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;
    Ruler ruler = Ruler(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MetricsProvider>(
          create: (_) => MetricsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CalibrationProvider(),
        ),
      ],
      child: Consumer2<MetricsProvider, CalibrationProvider>(
        builder: (context, metrics, calibrationMode, _) => Scaffold(
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
          body: FutureBuilder(
              future: ruler.getPhoneDpi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Stack(
                    children: <Widget>[
                      Text('Future Ruler, dpi=${ruler.dpi}')
                    ],
                  );
                }
              }),
          drawer: HomeDrawer(
            appName: args.name,
            avatarPath: args.assetPath,
            drawerContent: const [ListTileUi()],
          ),
        ),
      ),
    );
  }
}
