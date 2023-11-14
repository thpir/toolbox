import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../controllers/message_controller.dart';
import '../../../controllers/storage/shared_prefs/shared_prefs_providers/ui_theme_provider.dart';
import '../../../controllers/torch_controller.dart';
import '../../../models/data/morse_code.dart';
import '../../../models/screen_props.dart';

class MorseEncoder extends StatefulWidget {
  const MorseEncoder({super.key});

  @override
  State<MorseEncoder> createState() => _MorseEncoderState();
}

class _MorseEncoderState extends State<MorseEncoder> {
  final TextEditingController textController = TextEditingController();
  final TorchController torchController = TorchController();
  bool _textToDecode = false;
  bool _playButtonAvailable = false;
  bool _repeatButtonAvailable = false;
  bool _playingOnce = false;
  bool _playingLoop = false;
  double _speed = 1.0;
  MessageController messageController = MessageController();

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
          await Future.delayed(
              Duration(milliseconds: ((dashDot * 1000) ~/ _speed)));
          setState(() {
            torchController.torchOff();
          });
          await Future.delayed(Duration(milliseconds: ((1 * 1000) ~/ _speed)));
          if (!_playingLoop && !_playingOnce) {
            break;
          }
        }
        await Future.delayed(Duration(milliseconds: ((3 * 1000) ~/ _speed)));
      } catch (error) {
        // No char
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiThemeProvider>(context, listen: true);

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

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          image: DecorationImage(
              image: AssetImage(checkUIMode(uiProvider.uiMode)
                  ? 'assets/images/background_toolbox_dark.png'
                  : 'assets/images/background_toolbox.png'),
              fit: BoxFit.cover)),
      child: Column(
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
                  labelText: 'edittext_label'.i18n(),
                  hintText: 'edittext_hint'.i18n(),
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
                        ? Text('button_stop'.i18n())
                        : Text('button_play_loop'.i18n())),
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
                        ? Text('button_stop'.i18n())
                        : Text('button_play_once'.i18n())),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Row(
              children: [
                const Text('Slow'),
                Expanded(
                  child: Slider(
                    value: _speed,
                    min: 0.2,
                    max: 1.8,
                    activeColor: Colors.amber,
                    inactiveColor: Theme.of(context).focusColor,
                    label: _speed.toStringAsFixed(1),
                    divisions: 16,
                    onChanged: (value) {
                      setState(() {
                        _speed = value;
                      });
                    },
                  ),
                ),
                const Text('Fast')
              ],
            ),
          )
        ],
      ),
    );
  }
}
