import 'package:flutter/material.dart';

class QRController extends ChangeNotifier {
  TextEditingController controller = TextEditingController();
  String qrData = '';
  final qrKey = GlobalKey();

}
