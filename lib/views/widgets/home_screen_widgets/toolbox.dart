import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localization/localization.dart';

import '../../../models/data/svg_data.dart';
import '../../../models/data/app_list.dart';
import '../../../models/app.dart';
import 'toolbox_instructions.dart';
import 'app_gridview.dart';

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
          const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
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
    timer = Timer.periodic(const Duration(milliseconds: 15), (Timer t) {
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
        ToolboxInstructions(width: width, height: height),
        AppGridview(height: height, animation: _animation, isListViewVisible: _isListViewVisible, width: width, searchList: searchList),
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
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TextField(
                controller: textController,
                onChanged: ((value) {
                  filterSearchResults(value);
                }),
                decoration: InputDecoration(
                  labelText: 'toolbox_widget_textfield_labeltext'.i18n(),
                  hintText: 'toolbox_widget_textfield_hinttext'.i18n(),
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}