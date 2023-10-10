
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:provider/provider.dart';
import 'package:toolbox/controllers/storage/shared_prefs/shared_prefs_providers/metrics_provider.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:localization/localization.dart';

import '../../models/app.dart';
import '../widgets/general_widgets/home_drawer.dart';
import '../widgets/general_widgets/list_tile_ui.dart';
import '../widgets/general_widgets/list_tile_metrics.dart';
import '../../controllers/message_controller.dart';

class ArRulerHomeScreen extends StatefulWidget {
  static const routeName = '/ar-ruler-homescreen';
  const ArRulerHomeScreen({super.key});

  @override
  State<ArRulerHomeScreen> createState() => _ArRulerHomeScreenState();
}

class _ArRulerHomeScreenState extends State<ArRulerHomeScreen> {
  MessageController messageController = MessageController();
  BuildContext? ctx;
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (arSessionManager != null) arSessionManager!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;
    ctx = context;

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
               _showInfoDialog(context);
              },
              icon: const Icon(Icons.info_outline)),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home)),
        ],
      ),
      body: Center(
        child: ARView(
          onARViewCreated: onARViewCreated,
          planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
        ),
      ),
      drawer: HomeDrawer(
        appName: args.name,
        avatarPath: args.assetPath,
        drawerContent: const [ListTileUi(), ListTileMetrics()],
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    _showInfoDialog(context);

    this.arSessionManager!.onInitialize(
          showAnimatedGuide: true,
          showFeaturePoints: false,
          showPlanes: true,
          showWorldOrigin: false,
        );
    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
  }

  Future<void> onRemoveEverything() async {
    for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    anchors = [];
    nodes = [];
  }

  Future<void> _showResultDialog(double? result, BuildContext context) async {
    final metricsProvider =
        Provider.of<MetricsProvider>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: result != null
              ? metricsProvider.metrics
                  ? Center(
                      child: Text(
                          'ar_ruler_result_leading'.i18n() + (result * 1000).round().toString() + 'ar_ruler_result_trailing_mm'.i18n()))
                  : Center(
                      child: Text(
                          'ar_ruler_result_leading'.i18n() + (result * 39.3700787).round().toString() + 'ar_ruler_result_trailing_inch'.i18n()))
              : Text('ar_ruler_result_error'.i18n()),
          actions: <Widget>[
            TextButton(
              child: Text('ar_ruler_result_close_button'.i18n()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _showInfoDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ar_ruler_info_dialog_title'.i18n()),
          icon: const Icon(Icons.info_outline),
          content: Text('ar_ruler_info_dialog_content'.i18n()),
          actions: <Widget>[
            TextButton(
              child: Text('ar_ruler_result_close_button'.i18n()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    if (anchors.length >= 2) {
      onRemoveEverything();
    }
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    var newAnchor =
        ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
    bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
    if (didAddAnchor!) {
      anchors.add(newAnchor);
      // Add note to anchor
      var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: "assets/pin_final.gltf",
          scale: Vector3(1, 1, 1),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));

      bool? didAddNodeToAnchor =
          await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
      if (didAddNodeToAnchor!) {
        nodes.add(newNode);
        if (anchors.length >= 2) {
          await arSessionManager!
              .getDistanceBetweenAnchors(anchors[0], anchors[1])
              .then((value) => _showResultDialog(value, context));
        }
      } else {
        arSessionManager!.onError('ar_ruler_node_error'.i18n());
        if (ctx != null) {
          ScaffoldMessenger.of(ctx!).showSnackBar(messageController
              .getErrorSnackbar('ar_ruler_node_error'.i18n()));
        }
      }
    } else {
      arSessionManager!.onError('ar_ruler_anchor_error'.i18n());
      if (ctx != null) {
        ScaffoldMessenger.of(ctx!).showSnackBar(
            messageController.getErrorSnackbar('ar_ruler_anchor_error'.i18n()));
      }
    }
  }
}
