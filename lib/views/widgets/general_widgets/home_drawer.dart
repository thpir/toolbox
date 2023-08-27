import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    required this.avatarPath, 
    required this.appName, 
    required this.drawerContent, 
    super.key
  });

  final String avatarPath;
  final String appName;
  final List<Widget> drawerContent;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage(avatarPath),
                ),
                const Spacer(),
                Text(
                  appName + 'home_drawer_widget_title'.i18n(),
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: drawerContent,
            ),
          ),
        ],
      ),
    );
  }
}
