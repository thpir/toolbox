import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import 'qr_title_widget.dart';

class QRScanWidget extends StatelessWidget {
  const QRScanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QRTitleWidget(title: 'scan_divider_text'.i18n()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: ElevatedButton.icon(
              onPressed: () {
                //Navigator.of(context).pushNamed(ScanScreen.routeName);
              },
              icon: const Icon(
                Icons.qr_code_scanner,
                color: Colors.black,
              ),
              label: Text(
                'scan_button_text'.i18n(),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}