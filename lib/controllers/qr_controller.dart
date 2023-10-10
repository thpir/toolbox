import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:localization/localization.dart';

import 'message_controller.dart';

class QRController extends ChangeNotifier {
  TextEditingController controller = TextEditingController();
  MessageController messageController = MessageController();
  String qrData = '';
  bool disableButton = true;
  bool permissionGranted = false;
  late RenderRepaintBoundary boundary;
  final qrKey = GlobalKey();

  initController() {
    print('>>>>>>>>>> initController called');
    controller.addListener(() {
      onTextFieldChange();
    });
  }

  disposeController() {
    print('>>>>>>>>>> initController disposed');
    controller.dispose();
  }

  onTextFieldChange() {
    disableButton = controller.text.isEmpty;
    print('>>>>>>>>>> disableButton= $disableButton');
    notifyListeners();
  }

  updateUI() {
    notifyListeners();
  }

  findRenderRepaintBoundary() {
    boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  }

  checkStoragePermissions() async {
    PermissionStatus res;
    res = await Permission.storage.request();
    permissionGranted = res.isGranted;
  }

  void takeScreenShot(BuildContext context) async {
    checkStoragePermissions();
    findRenderRepaintBoundary();
    // We can increse the size of QR using pixel ratio
    final image = await boundary.toImage(pixelRatio: 5.0);
    final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
    DateTime now = DateTime.now();
    int timeStamp = now.millisecondsSinceEpoch;
    if (byteData != null) {
      final pngBytes = byteData.buffer.asUint8List();
      final directory = (await getApplicationDocumentsDirectory()).path;
      final imgFile = File(
        '$directory/QR_$timeStamp.png',
      );
      imgFile.writeAsBytes(pngBytes);
      GallerySaver.saveImage(imgFile.path, albumName: 'QR-Code')
          .then((success) async {
        ScaffoldMessenger.of(context).showSnackBar(
            messageController.getInformationalSnackbar(
                'confirm_message_qr_saved'.i18n(), context));
        controller.clear();
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
            messageController.getErrorSnackbar(error.toString()));
      });
    }
  }
}
