import 'package:flutter/material.dart';
import 'package:toolbox/controllers/message_controller.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../models/app.dart';
import '../../models/screen_props.dart';
import '../../models/data/morse_code.dart';
import '../widgets/general_widgets/home_drawer.dart';
import '../widgets/general_widgets/list_tile_ui.dart';
import '../../controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';
import '../../controllers/torch_controller.dart';

class FlashlightHomeScreen extends StatefulWidget {
  static const routeName = '/flashlight-homescreen';
  const FlashlightHomeScreen({super.key});

  @override
  State<FlashlightHomeScreen> createState() => _FlashlightHomeScreenState();
}

class _FlashlightHomeScreenState extends State<FlashlightHomeScreen> {
  final TorchController torchController = TorchController();
  bool _textToDecode = false;
  bool _playButtonAvailable = false;
  bool _repeatButtonAvailable = false;
  bool _playingOnce = false;
  bool _playingLoop = false;
  MessageController messageController = MessageController();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    torchController.isTorchAvailable();
    super.initState();
  }

  @override
  void dispose() {
    torchController.torchOff();
    super.dispose();
  }

  bool _checkUIMode(String uiMode) {
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

  Future _decodeText(String text) async {
    List<String> stringChars = text.split("");
    for (String char in stringChars) {
      char[0].toLowerCase;
      try {
        Pair selectedPair =
            MorseCode.decodeList.firstWhere((pair) => pair.char == char);
        for (int dashDot in selectedPair.code) {
          setState(() {
            torchController.torchOn();
          });
          await Future.delayed(Duration(seconds: dashDot));
          setState(() {
            torchController.torchOff();
          });
          await Future.delayed(const Duration(seconds: 1));
          if (!_playingLoop && !_playingOnce) {
            break;
          }
        }
        await Future.delayed(const Duration(seconds: 3));
      } catch (error) {
        // No char
      }
    }
  }

  List<Widget> _tabChildren() {
    return [
      Center(
        child: Image.asset(
          _checkUIMode(
                  Provider.of<UiThemeProvider>(context, listen: false).uiMode)
              ? 'assets/images/international_morse_code_dark.png'
              : 'assets/images/international_morse_code.png',
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                if (torchController.flashOn) {
                  await torchController.torchOff();
                  setState(() {});
                } else {
                  await torchController.torchOn();
                  setState(() {});
                }
              },
              child: CircleAvatar(
                radius: 50,
                child: Icon(
                  torchController.flashOn ? Icons.flashlight_on : Icons.flashlight_off,
                  size: 64,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(torchController.flashOn ? 'Flashlight On' : 'Flashlight Off',
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TextField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: textController,
                minLines: 1,
                maxLines: 10,
                onChanged: ((value) {
                  if (value != '') {
                    setState(() {
                      _textToDecode = true;
                      _playButtonAvailable = true;
                      _repeatButtonAvailable = true;
                    });
                  } else {
                    setState(() {
                      _textToDecode = false;
                      _playButtonAvailable = false;
                      _repeatButtonAvailable = false;
                      _playingLoop = false;
                      _playingOnce = false;
                    });
                  }
                  setState(() {
                    _playingLoop = false;
                    _playingOnce = false;
                  });
                }),
                decoration: InputDecoration(
                  labelText: 'Morse Encoder',
                  hintText: 'Enter text to encode',
                  suffixIcon: _textToDecode
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              textController.clear();
                              _textToDecode = false;
                              _playButtonAvailable = false;
                              _repeatButtonAvailable = false;
                              _playingLoop = false;
                              _playingOnce = false;
                            });
                          },
                          icon: const Icon(Icons.close))
                      : null,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton.icon(
                    onPressed: _repeatButtonAvailable
                        ? () async {
                            if (_playingLoop) {
                              setState(() {
                                _playingLoop = false;
                                _playButtonAvailable = true;
                              });
                            } else {
                              setState(() {
                                _playingLoop = true;
                                _playButtonAvailable = false;
                              });
                              while (_playingLoop) {
                                await _decodeText(textController.text);
                              }
                            }
                          }
                        : null,
                    icon: _playingLoop
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.repeat),
                    label: _playingLoop
                        ? const Text('Stop')
                        : const Text('Play Loop')),
              ),
              const SizedBox(
                width: 40,
              ),
              Expanded(
                child: ElevatedButton.icon(
                    onPressed: _playButtonAvailable
                        ? () async {
                            if (_playingOnce) {
                              setState(() {
                                _playingOnce = false;
                                _repeatButtonAvailable = true;
                              });
                            } else {
                              setState(() {
                                _playingOnce = true;
                                _repeatButtonAvailable = false;
                              });
                              await _decodeText(textController.text);
                              setState(() {
                                _playingOnce = false;
                                _repeatButtonAvailable = true;
                              });
                            }
                          }
                        : null,
                    icon: _playingOnce
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.repeat_one),
                    label: _playingOnce
                        ? const Text('Stop')
                        : const Text('Play once')),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as App;

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
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
          bottom:
              TabBar(indicatorColor: Theme.of(context).focusColor, tabs: const [
            Tab(
              child: Text(
                'Morse\nChart',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Flashlight',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Morse\nEncoder',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: _tabChildren()),
        drawer: HomeDrawer(
          appName: args.name,
          avatarPath: args.assetPath,
          drawerContent: const [ListTileUi()],
        ),
      ),
    );
  }
}
