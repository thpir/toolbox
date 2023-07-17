import 'package:flutter/material.dart';

import '../widgets/toolbox.dart';
import '../widgets/custom_about_dialog.dart';
import '../widgets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.title, super.key});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Method to display the about dialog with information about me and the app.
  Future<void> _showAboutDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        CustomAboutDialog customAboutDialog = CustomAboutDialog();
        return customAboutDialog.getDialog(context);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _showAboutDialog,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              alignment: Alignment.bottomCenter,
              child: Toolbox(
                width: width-20,
              ),
            )
          ],
        ),
      ),
      drawer: const HomeDrawer(),
    );
  }
}
