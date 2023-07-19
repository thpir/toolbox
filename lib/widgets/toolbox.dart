import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import '../data/svg_data.dart';
import '../data/app_list.dart';
import '../models/app.dart';
import './app_tile.dart';

class Toolbox extends StatefulWidget {
  const Toolbox({super.key});

  @override
  State<Toolbox> createState() => _ToolboxState();
}

class _ToolboxState extends State<Toolbox> with SingleTickerProviderStateMixin {
  SvgData svgData = SvgData();
  AppList appList = AppList();
  var searchList = <App>[];
  int currentIndex = 0;
  bool closed = true;
  Timer? timer;
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isListViewVisible = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchList = appList.appList;
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
    );
    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    setState(() {
      searchList = appList.appList
          .where((app) => app.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleListViewVisibility() {
    setState(() {
      _isListViewVisible = !_isListViewVisible;
      if (_isListViewVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void changeImage() {
    setState(() {
      if (closed) {
        if (currentIndex < svgData.toolboxList.length - 1) {
          currentIndex++;
        }
      } else {
        if (currentIndex > 0) {
          currentIndex--;
        }
      }
    });
  }

  void startImageTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 50), (Timer t) {
      if (closed) {
        if (currentIndex == svgData.toolboxList.length - 1) {
          timer?.cancel();
          closed = false;
        } else {
          changeImage();
        }
      } else {
        if (currentIndex == 0) {
          timer?.cancel();
          closed = true;
        } else {
          changeImage();
        }
      }
    });
    _toggleListViewVisibility();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: width,
          height: height,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tab the toolbox to access your tools',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.ads_click,
                  color: Theme.of(context).focusColor,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: height, //height - (width * 0.5),
            child: SlideTransition(
              position: _animation,
              child: Visibility(
                visible: _isListViewVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 80, bottom: width * 0.6),
                    itemCount: searchList.length,
                    itemBuilder: (context, index) {
                      return AppTile(
                        name: searchList[index].name,
                        assetpath: searchList[index].assetPath,
                        size: width / 3.5,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: width,
            height: width * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: startImageTimer,
                child: SvgPicture.string(
                  svgData.toolboxList[currentIndex],
                  width: width,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: TextField(
              controller: textController,
              onChanged: ((value) {
                filterSearchResults(value);
              }),
              decoration: InputDecoration(
                  labelText: "Search app...",
                  hintText: "Search app...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
        )
      ],
    );
  }
}
