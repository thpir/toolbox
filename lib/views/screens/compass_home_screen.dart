import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:localization/localization.dart';

import '../../models/app.dart';
import '../../models/screen_props.dart';
import '../../views/widgets/general_widgets/home_drawer.dart';
import '../../views/widgets/general_widgets/list_tile_ui.dart';
import '../../views/widgets/compass_screen_widgets/compass.dart';
import '../../views/widgets/compass_screen_widgets/map.dart';

class CompassHomeScreen extends StatefulWidget {
  static const routeName = '/compass-homescreen';
  const CompassHomeScreen({super.key});

  @override
  State<CompassHomeScreen> createState() => _CompassHomeScreenState();
}

class _CompassHomeScreenState extends State<CompassHomeScreen> {
  bool _hasPermissions = false;
  bool _centered = true;
  static const _alignments = [
    Alignment.center,
    Alignment.topLeft,
  ];

  AlignmentGeometry get _alignment =>
      _centered ? _alignments[0] : _alignments[1];

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
      body: Stack(
        children: _centered 
          ? <Widget>[
            AnimatedAlign(
              alignment: _alignment,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Builder(builder: (context) {
                  if (_hasPermissions) {
                    return Compass(width: _centered ? width : 100, centered: _centered,);
                  } else {
                    return getDialog(context);
                  }
                }),
              ),
            ),
          ] 
        : <Widget>[
            const Map(),
            AnimatedAlign(
              alignment: _alignment,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Builder(builder: (context) {
                  if (_hasPermissions) {
                    return Compass(width: _centered ? width : 100, centered: _centered,);
                  } else {
                    return getDialog(context);
                  }
                }),
              ),
            ),
          ] ,
      ),
      drawer: HomeDrawer(
        appName: args.name,
        avatarPath: args.assetPath,
        drawerContent: const [ListTileUi()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _centered = !_centered;
          });
        },
        backgroundColor: Colors.amber,
        child: Icon(
          _centered ? Icons.map_outlined : Icons.navigation_outlined, 
          color: Colors.black,
        ),
      ),
    );
  }
}
