import 'package:barcode_parser/barcode_parser.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'qr_title_widget.dart';

class ContactScanWidget extends StatelessWidget {
  const ContactScanWidget(
      {required this.barcodeContactInfo, required this.context, super.key});

  final BarcodeContactInfo barcodeContactInfo;
  final BuildContext context;

  SnackBar _showMessage(String message) {
    return SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    Contact contact = Contact.fromVCard(barcodeContactInfo.rawValue);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Text(
              'qr_result_name_placeholder'.i18n() + contact.displayName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: contact.emails.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Text(
                  'qr_result_email_placeholder'.i18n() + item.address,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList()
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: contact.phones.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    'qr_result_phone_placeholder'.i18n() + item.number,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList()
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: contact.addresses.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    'qr_result_address_placeholder'.i18n() + item.address,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList()
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: contact.websites.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    'qr_result_url_placeholder'.i18n() + item.url,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList()
          ),
          QRTitleWidget(title: 'actions_divider_text'.i18n()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: ElevatedButton(
                onPressed: () async {
                  //final contactToExport = await FlutterContacts();
                },
                child: Text(
                  'button_text_save_contact'.i18n(),
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
                  Clipboard.setData(
                          ClipboardData(text: barcodeContactInfo.rawValue))
                      .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                          _showMessage(
                              'scaffold_message_copy_url_clipboard'.i18n())));
                },
                child: Text(
                  'button_text_copy_contact'.i18n(),
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