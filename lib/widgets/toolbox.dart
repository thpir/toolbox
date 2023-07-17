import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/svg_data.dart';

class Toolbox extends StatefulWidget {
  const Toolbox({required this.width, super.key});

  final double width; 

  @override
  State<Toolbox> createState() => _ToolboxState();
}

class _ToolboxState extends State<Toolbox> {
  SvgData svgData = SvgData();
  int currentIndex = 0;
  bool closed = true;
  Timer? timer;

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: startImageTimer,
        child: SvgPicture.string(
          svgData.toolboxList[currentIndex],
          width: widget.width,
        ),
      ),
    );
  }
}
