import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:barcode_parser/barcode_parser.dart';
import 'package:flutter/services.dart';

import '../widgets/qr_screen_widgets/contact_scan_widget.dart';
import '../widgets/qr_screen_widgets/url_scan_widget.dart';
import '../../controllers/message_controller.dart';

class QRCodeResultScreen extends StatelessWidget {
  static const routeName = '/qr-code-result-screen';
  const QRCodeResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments as String;

    Widget parseBarcode(String scannedString) {
      BarcodeParser barcodeParser = BarcodeParser();
      Barcode barcode = barcodeParser.parse(scannedString);

      switch (barcode.valueType) {
        case BarcodeValueType.url:
          BarcodeUrl barcodeUrl = barcode as BarcodeUrl;
          return UrlScanWidget(barcodeUrl: barcodeUrl, context: context);

        case BarcodeValueType.wifi:
          BarcodeWifi barcodeWifi = barcode as BarcodeWifi;
          return Center(
            child: Text(
              'qr_result_text_wifi'.i18n() + barcodeWifi.toString() + 'qr_result_trailing_text_wifi'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );

        case BarcodeValueType.contactInfo:
          BarcodeContactInfo barcodeContactInfo = barcode as BarcodeContactInfo;
          return ContactScanWidget(
            barcodeContactInfo: barcodeContactInfo,
            context: context,
          );

        case BarcodeValueType.location:
          BarcodeLocation barcodeLocation = barcode as BarcodeLocation;
          return Center(
            child: Text(
              'qr_result_text_location'.i18n() + barcodeLocation.toString() + 'qr_result_trailing_text_location'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        case BarcodeValueType.email:
          BarcodeEmail barcodeEmail = barcode as BarcodeEmail;
          return Center(
            child: Text(
              'qr_result_text_email'.i18n() + barcodeEmail.toString() + 'qr_result_trailing_text_email'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        case BarcodeValueType.sms:
          BarcodeSms barcodeSms = barcode as BarcodeSms;
          return Center(
            child: Text(
              'qr_result_text_sms'.i18n() + barcodeSms.toString() + 'qr_result_trailing_text_sms'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        case BarcodeValueType.calendarEvent:
          BarcodeCalendarEvent barcodeCalendarEvent =
              barcode as BarcodeCalendarEvent;
          return Center(
            child: Text(
              'qr_result_text_calendar'.i18n() + barcodeCalendarEvent.toString() + 'qr_result_trailing_text_calendar'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        case BarcodeValueType.phone:
          BarcodePhone barcodePhone = barcode as BarcodePhone;
          return Center(
            child: Text(
              'qr_result_text_phone'.i18n() + barcodePhone.toString() + 'qr_result_trailing_text_phone'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        case BarcodeValueType.driverLicense:
          BarcodeDriverLicense barcodeDriverLicense =
              barcode as BarcodeDriverLicense;
          return Center(
            child: Text(
              'qr_result_text_licence'.i18n() + barcodeDriverLicense.toString() + 'qr_result_trailing_text_licence'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        case BarcodeValueType.product:
          BarcodeProduct barcodeProduct = barcode as BarcodeProduct;
          return Center(
            child: Text(
              'qr_result_text_product'.i18n() + barcodeProduct.rawValue,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        case BarcodeValueType.text:
          BarcodeText barcodeText = barcode as BarcodeText;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'qr_result_text_text'.i18n() + barcodeText.rawValue,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        MessageController messageController =
                            MessageController();
                        Clipboard.setData(
                                ClipboardData(text: barcodeText.rawValue))
                            .then((value) => ScaffoldMessenger.of(context)
                                .showSnackBar(
                                    messageController.getInformationalSnackbar(
                                        'scaffold_message_copy_clipboard'
                                            .i18n(),
                                        context)));
                      },
                      child: Text(
                        'button_text_copy_text'.i18n(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // add google button: googleSearch = "https://www.google.com/search?q=" + data;
                ],
              ),
            ),
          );
        default:
          return Center(
            child: Text(
              'qr_result_text_not_supported'.i18n(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('appbar_result_text'.i18n(),
              style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', ((route) => false));
              },
              icon: const Icon(Icons.home),
            ),
          ],
        ),
        body: parseBarcode(result));
  }
}
