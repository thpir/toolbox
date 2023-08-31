import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/ruler_home_screen_widgets/horizontal_ruler.dart';
import '../widgets/ruler_home_screen_widgets/vertical_ruler.dart';
import '../widgets/ruler_home_screen_widgets/ruler_origin.dart';
import '../widgets/ruler_home_screen_widgets/sliders.dart';
import '../widgets/general_widgets/home_drawer.dart';
import '../widgets/general_widgets/list_tile_ui.dart';
import '../widgets/general_widgets/list_tile_metrics.dart';
import '../widgets/general_widgets/list_tile_calibration.dart';
import '../../models/app.dart';
import '../../controllers/ruler_controller.dart';
import '../../controllers/storage/shared_prefs/shared_prefs_providers/calibration_provider.dart';
import '../../controllers/storage/shared_prefs/shared_prefs_providers/metrics_provider.dart';

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
    RulerController rulerController = RulerController(context);

    return Consumer2<MetricsProvider, CalibrationProvider>(
      builder: (context, metrics, calibrationMode, _) => Scaffold(
        appBar: AppBar(
          title: Text(args.name),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.home)),
            IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/ruler-measurement-list-screen');
            },
            icon: const Icon(
              Icons.history_sharp,
            ),
          ),
          ],
        ),
        body: FutureBuilder(
            future: rulerController.getPhoneDpi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                rulerController.mm = metrics.metrics;
                rulerController.standardCalibration = calibrationMode.calibrationMode;
                rulerController.calibrationValue = calibrationMode.calibrationValue;
                return Stack(
                  children: <Widget>[
                    VerticalRuler(
                        rulerController: rulerController,
                    ),
                    HorizontalRuler(
                        rulerController: rulerController,
                    ),
                    RulerOrigin(
                      rulerController: rulerController,
                    ),
                    Sliders(
                      rulerController: rulerController,
                    )
                  ],
                );
              }
            }),
        drawer: HomeDrawer(
          appName: args.name,
          avatarPath: args.assetPath,
          drawerContent: const [ListTileUi(), ListTileMetrics(), ListTileCalibration()],
        ),
      ),
    );
  }
}
