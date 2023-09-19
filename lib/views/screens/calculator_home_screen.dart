import 'package:flutter/material.dart';

import '../../models/app.dart';
import '../../models/screen_props.dart';
import '../widgets/general_widgets/home_drawer.dart';
import '../widgets/general_widgets/list_tile_ui.dart';
import '../widgets/calculator_widgets/calculator_button.dart';

class CalculatorHomeScreen extends StatelessWidget {
  static const routeName = '/calculator-homescreen';
  const CalculatorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;
    double width = ScreenProps.getScreenWidth(context);
    if (width > 700) {
      width = 700;
    }
    double height =
        ScreenProps.getScreenHeight(context) - ScreenProps.getAppBarHeight();
    if (height > 1000) {
      width = 1000;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(args.name,
            style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home)),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.grey)),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          '0', 
                          style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontSize: 40
                          )),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CalculatorButton(btnColor: Colors.grey[600], btnText: 'AC', flex: 1),
                      CalculatorButton(btnColor: Colors.grey[600], btnText: '+/-', flex: 1),
                      CalculatorButton(btnColor: Colors.grey[600], btnText: '%', flex: 1),
                      const CalculatorButton(btnColor: Colors.amber, btnText: '÷', flex: 1),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '7', flex: 1),
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '8', flex: 1),
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '9', flex: 1),
                      const CalculatorButton(btnColor: Colors.amber, btnText: '×', flex: 1),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '4', flex: 1),
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '5', flex: 1),
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '6', flex: 1),
                      const CalculatorButton(btnColor: Colors.amber, btnText: '-', flex: 1),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '1', flex: 1),
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '2', flex: 1),
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '3', flex: 1),
                      const CalculatorButton(btnColor: Colors.amber, btnText: '+', flex: 1),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CalculatorButton(btnColor: Colors.grey[400], btnText: '0', flex: 2),
                      CalculatorButton(btnColor: Colors.grey[400], btnText: ',', flex: 1),
                      const CalculatorButton(btnColor: Colors.amber, btnText: '=', flex: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: HomeDrawer(
        appName: args.name,
        avatarPath: args.assetPath,
        drawerContent: const [ListTileUi()],
      ),
    );
  }
}
