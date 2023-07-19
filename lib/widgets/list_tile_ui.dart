import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../shared_prefs/ui_theme_preference.dart';
import '../providers/ui_theme_provider.dart';

class ListTileUi extends StatefulWidget {
  const ListTileUi({super.key});

  @override
  State<ListTileUi> createState() => _ListTileUiState();
}

class _ListTileUiState extends State<ListTileUi> {
  String uiMode = 'ui';

  @override
  void initState() {
    super.initState();
    getUiTheme().then((value) {
      setState(() {
        uiMode = value.toString();
      });
    });
  }

  Future<String> getUiTheme() async {
    UiThemePreference uiThemePreferene = UiThemePreference();
    return uiThemePreferene.getUiTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<UiThemeProvider>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'list_tile_ui_widget_title'.i18n(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'list_tile_ui_widget_radio_list_tile_ui'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: 'ui',
            groupValue: uiMode,
            onChanged: ((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            })),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'list_tile_ui_widget_radio_list_tile_dark'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: 'dark',
            groupValue: uiMode,
            onChanged: ((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            })),
        RadioListTile(
            activeColor: Colors.amber,
            title: Text(
              'list_tile_ui_widget_radio_list_tile_light'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: 'light',
            groupValue: uiMode,
            onChanged: ((value) async {
              setState(() {
                uiMode = value.toString();
              });
              themeChange.uiMode = value.toString();
            }
          ),
        ),
      ],
    );
  }
}
