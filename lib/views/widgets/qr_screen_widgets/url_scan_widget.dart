import 'package:flutter/material.dart';
import 'package:barcode_parser/barcode_parser.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'qr_title_widget.dart';

class UrlScanWidget extends StatelessWidget {
  const UrlScanWidget({required this.barcodeUrl, required this.context, super.key});

  final BarcodeUrl barcodeUrl;
  final BuildContext context;

  Future<void> _launchUrl(String barcode) async {
    Uri url = Uri.parse(barcode);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('error_text_launch_url'.i18n() + url.toString());
    }
  }

  SnackBar _showMessage(String message) {
    return SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Text(
              barcodeUrl.rawValue,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          QRTitleWidget(title: 'actions_divider_text'.i18n()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: ElevatedButton(
                onPressed: () {
                  _launchUrl(barcodeUrl.rawValue);
                },
                child: Text(
                  'button_text_open_url'.i18n(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: barcodeUrl.rawValue))
                      .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                          _showMessage(
                              'scaffold_message_copy_url_clipboard'.i18n())));
                },
                child: Text(
                  'button_text_copy_url'.i18n(),
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
      ),
    );
  }
}
