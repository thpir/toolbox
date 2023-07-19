import 'package:flutter/material.dart';

import './list_tile_ui.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/icon_toolbox_color.png'),
                ),
                const Spacer(),
                Text(
                  'Toolbox Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select your theme:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const ListTileUi(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
