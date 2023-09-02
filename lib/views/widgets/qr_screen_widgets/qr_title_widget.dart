import 'package:flutter/material.dart';

class QRTitleWidget extends StatelessWidget {
  const QRTitleWidget({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: Theme.of(context).focusColor,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: Theme.of(context).focusColor,
            ),
          ),
        ],
      ),
    );
  }
}
