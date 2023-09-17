import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app.dart';
import '../../controllers/qr_controller.dart';
import '../widgets/qr_screen_widgets/qr_scan_widget.dart';
import '../widgets/qr_screen_widgets/qr_create_widget.dart';
import '../widgets/general_widgets/home_drawer.dart';
import '../widgets/general_widgets/list_tile_ui.dart';

class QRCodeHomeScreen extends StatelessWidget {
  static const routeName = '/qr-code-homescreen';
  const QRCodeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<QRController>(
            create: (_) => QRController(),
          ),
        ],
        child: Consumer<QRController>(
          builder: (context, qrController, child) {
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
                body: const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      QRScanWidget(),
                      QRCreateWidget(),
                    ],
                  ),
                ),
                drawer: HomeDrawer(
                  appName: args.name,
                  avatarPath: args.assetPath,
                  drawerContent: const [ListTileUi()],
                ),
                floatingActionButton: qrController.qrData == ''
                    ? null
                    : FloatingActionButton(
                        onPressed: () {
                          qrController.takeScreenShot(context);
                        },
                        backgroundColor: Colors.amber,
                        child: const Icon(
                          Icons.save,
                          color: Colors.black,
                        ),
                      ));
          },
        ));
  }
}
