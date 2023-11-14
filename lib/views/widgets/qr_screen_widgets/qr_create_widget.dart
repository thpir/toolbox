import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../controllers/qr_controller.dart';
import 'qr_title_widget.dart';
import 'qr_placeholder.dart';

class QRCreateWidget extends StatefulWidget {
  const QRCreateWidget({super.key});

  @override
  State<QRCreateWidget> createState() => _QRCreateWidgetState();
}

class _QRCreateWidgetState extends State<QRCreateWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    final qrController = Provider.of<QRController>(context, listen: false);
    qrController.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrController = Provider.of<QRController>(context);
    qrController.initController();
    return Column(
      children: [
        QRTitleWidget(title: 'create_divider_text'.i18n()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: TextField(
            controller: qrController.controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'textfield_url_text'.i18n(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: ElevatedButton.icon(
              onPressed: qrController.disableButton
                  ? null
                  : () {
                      setState(() {
                        qrController.qrData = qrController.controller.text;
                        FocusManager.instance.primaryFocus?.unfocus();
                        qrController.updateUI();
                      });
                    },
              icon: const Icon(
                Icons.qr_code_2,
                color: Colors.black,
              ),
              label: Text(
                'generate_qr_code_button_text'.i18n(),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 300,
          height: 300,
          alignment: Alignment.center,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Theme.of(context).colorScheme.background,
            child: Container(
              width: 300,
              height: 300,
              alignment: Alignment.center,
              child: qrController.qrData == ''
                  ? const QrPlaceHolder()
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        RepaintBoundary(
                            key: qrController.qrKey,
                            child: QrImageView(
                              data: qrController.qrData,
                              //embeddedImage: TODO,
                              //semanticsLabel: TODO,
                              size: 250,
                              backgroundColor: Colors.white,
                              version: QrVersions.auto,
                            )),
                        Container(
                          constraints: const BoxConstraints.expand(),
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                qrController.qrData = '';
                              });
                              qrController.updateUI();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        )
      ],
    );
  }
}
