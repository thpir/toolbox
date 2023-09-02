import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:localization/localization.dart';

import '../../models/app.dart';
import '../../models/screen_props.dart';
import '../../views/widgets/general_widgets/home_drawer.dart';
import '../../views/widgets/general_widgets/list_tile_ui.dart';
import '../../views/widgets/compass_screen_widgets/compass.dart';

class CompassHomeScreen extends StatefulWidget {
  static const routeName = '/compass-homescreen';
  const CompassHomeScreen({super.key});

  @override
  State<CompassHomeScreen> createState() => _CompassHomeScreenState();
}

class _CompassHomeScreenState extends State<CompassHomeScreen> {
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  AlertDialog getDialog(BuildContext context) {
    return AlertDialog(
      content: Text('location_needed_text'.i18n()),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Permission.locationWhenInUse.request().then((ignored) {
              _fetchPermissionStatus();
            });
            Navigator.of(context).pop();
          },
          child: Text(
            'permissions_text'.i18n(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        TextButton(
          onPressed: () {
            openAppSettings().then((opened) {});
            Navigator.of(context).pop();
          },
          child: Text(
            'open_settings_text'.i18n(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;
    double width = ScreenProps.getScreenWidth(context);
    if (width > 700) {
      width = 700;
    }
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
      body: Center(child: Builder(builder: (context) {
        if (_hasPermissions) {
          return Compass(width: width);
        } else {
          return getDialog(context);
        }
      })),
      drawer: HomeDrawer(
        appName: args.name,
        avatarPath: args.assetPath,
        drawerContent: const [ListTileUi()],
      ),
    );
  }
}
