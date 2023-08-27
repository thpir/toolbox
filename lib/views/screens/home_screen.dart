import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../widgets/home_screen_widgets/toolbox.dart';
import '../widgets/home_screen_widgets/custom_about_dialog.dart';
import '../widgets/general_widgets/home_drawer.dart';
import '../widgets/general_widgets/list_tile_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  // Method to display the about dialog with information about me and the app.
  Future<void> _showAboutDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          CustomAboutDialog customAboutDialog = CustomAboutDialog();
          return customAboutDialog.getDialog(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.i18n()),
        actions: [
          IconButton(
            onPressed: _showAboutDialog,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: const Toolbox(),
      drawer: HomeDrawer(
        avatarPath: 'assets/images/icon_toolbox_color.png',
        appName: 'app_name'.i18n(),
        drawerContent: const [ListTileUi()],
      ),
    );
  }
}
