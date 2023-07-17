import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/svg_data.dart';
import './app_tile.dart';

class Toolbox extends StatefulWidget {
  const Toolbox({super.key});

  @override
  State<Toolbox> createState() => _ToolboxState();
}

class _ToolboxState extends State<Toolbox> with SingleTickerProviderStateMixin {
  SvgData svgData = SvgData();
  int currentIndex = 0;
  bool closed = true;
  Timer? timer;
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isListViewVisible = false;

  @override
  void initState() {
    super.initState();
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
            height: height - (width * 0.5),
            child: SlideTransition(
              position: _animation,
              child: Visibility(
                visible: _isListViewVisible,
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: 20, // Adjust the number of items as needed
                    itemBuilder: (context, index) {
                      return AppTile();
                    },
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
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                ],
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
      ],
    );
  }
}
