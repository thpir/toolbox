import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class QrPlaceHolder extends StatelessWidget {
  const QrPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.qr_code_2,
              color: Colors.black26,
              size: 250,
            ),
            Text(
              'no_qr_text'.i18n(),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
