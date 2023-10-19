import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/app.dart';
import '../../../controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';
import '../../../models/screen_props.dart';
import 'app_tile.dart';

class AppGridview extends StatelessWidget {
  const AppGridview({
    super.key,
    required this.height,
    required Animation<Offset> animation,
    required bool isListViewVisible,
    required this.width,
    required this.searchList,
  })  : _animation = animation,
        _isListViewVisible = isListViewVisible;

  final double height;
  final Animation<Offset> _animation;
  final bool _isListViewVisible;
  final double width;
  final List<App> searchList;

  @override
  Widget build(BuildContext context) {
    final uiThemeProvider = Provider.of<UiThemeProvider>(context);

    bool checkUIMode(String uiMode) {
      if (uiMode == 'dark') {
        return true;
      } else if (uiMode == 'light') {
        return false;
      } else {
        final darkMode = ScreenProps.isDarkMode(context);
        if (darkMode) {
          return true;
        } else {
          return false;
        }
      }
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            image: DecorationImage(
                image: AssetImage(checkUIMode(uiThemeProvider.uiMode) ? 'assets/images/background_toolbox_dark.png': 'assets/images/background_toolbox.png'),
                fit: BoxFit.cover)),
        height: height,
        child: SlideTransition(
          position: _animation,
          child: Visibility(
            visible: _isListViewVisible,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 80, bottom: width * 0.6),
                itemCount: searchList.length,
                itemBuilder: (context, index) {
                  return AppTile(
                    name: searchList[index].name,
                    assetpath: searchList[index].assetPath,
                    route: searchList[index].route,
                    size: width / 4,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
