import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAboutDialog {

  final Uri _url = Uri.parse('https://www.buymeacoffee.com/thpir');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  AlertDialog getDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('About this app'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Toolbox is a collection of useful tools that are a must-have on every smartphone. Instead of loads of different small apps I have bundeled them into one super-app, making it a digital swiss army knife!'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            const Text('If you like my work, please consider buying me a coffee.'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            const Text('Created by'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/thpir_logo.png',
                ),
              ),
            )
          ]
        ),
      ),
      actions: <Widget>[
        TextButton.icon(
          onPressed: () {
            _launchUrl();
            Navigator.of(context).pop();
          },
          label: Text(
            'Buy Coffee',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          icon: Icon(
            Icons.coffee_sharp,
            color: Theme.of(context).focusColor,
          )
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          label: Text(
            'Close',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          icon: Icon(
            Icons.close,
            color: Theme.of(context).focusColor,
          )
        ),
      ],
    );
  } 
}