import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:nfc_io/nfc_io.dart';
import 'package:terminal_app/pages/user_detail.dart';
import 'package:terminal_app/services/user_service.dart';
import 'package:terminal_app/utils/camera.service.dart';
import 'package:terminal_app/utils/convert.dart';
import 'package:terminal_app/utils/face_service.dart';
import 'package:terminal_app/utils/toast_message.dart';
import 'package:terminal_app/widgets/camera_footer.dart';
import 'package:terminal_app/widgets/camera_header.dart';

class InOut extends StatefulWidget {
  final isInput;
  InOut({Key key, this.isInput}) : super(key: key);

  @override
  _InOutState createState() => _InOutState();
}

class _InOutState extends State<InOut> {
  CameraService cameraService = CameraService();
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
  FaceService faceService = FaceService();
  bool detectingFaces = false;
  Future cameraFuture;
  Face face;
  Size imageSize;
  bool load = false;

  NfcData data;
  String cardNo;
  StreamSubscription _subscription;
  @override
  void initState() {
    super.initState();

    startCam();
    startNfc();
  }

  @override
  void dispose() {
    cameraService.cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          cameraService.camView(context, cameraFuture, face, imageSize),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CameraHeader(isInput: widget.isInput),
              load ? CircularProgressIndicator() : Center(),
              CameraFooter(),
            ],
          ),
        ],
      ),
    );
  }

  startCam() async {
    List<CameraDescription> cameras = await availableCameras();
    final CameraDescription cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );
    cameraFuture = cameraService.startService(cameraDescription);
    await cameraFuture;
    setState(() {});
    frameFaces();
  }

  frameFaces() {
    imageSize = cameraService.getImageSize();
    cameraService.cameraController.startImageStream((image) async {
      if (cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (detectingFaces) return;

        detectingFaces = true;

        try {
          var inputImage =
              Convert.toInputImage(image, cameraService.cameraRotation);
          List<Face> faces = await faceDetector.processImage(inputImage);
          if (faces != null) {
            if (faces.length > 0) {
              setState(() {
                face = faces[0];
              });
              if (ctrl) {
                await Future.delayed(Duration(milliseconds: 500));
                setState(() {
                  load = true;
                });
                await Future.delayed(Duration(milliseconds: 200));
                await faceService.setCurrentFace(image, face);
                cardNo = await faceService.searchResult();
                faceService.clearFacedata();
                if (cardNo.isNotEmpty) {
                  route();
                } else {
                  setState(() {
                    load = false;
                  });
                }
              }
            } else {
              setState(() {
                face = null;
                load = false;
              });
            }
          }
          detectingFaces = false;
        } catch (e) {
          print(e);
          detectingFaces = false;
        }
      }
    });
  }

  bool get ctrl {
    if (imageSize == null || face == null) return false;
    var left =
        (imageSize.width - face.boundingBox.right) > imageSize.width / 10;
    var right = face.boundingBox.left > imageSize.width / 10;
    var bottom =
        (imageSize.height - face.boundingBox.bottom) > imageSize.height / 5;
    var top = face.boundingBox.top > imageSize.height / 5;
    return left && right && bottom && top;
  }

  startNfc() {
    _subscription = NfcIo.startReading.listen((data) {
      setState(() {
        this.data = data;
        cardNo = Convert.hextoDecimal(data.id);
        route();
      });
    });
  }

  stopServices() async {
    if (_subscription != null) {
      _subscription.cancel();
      var result = await NfcIo.stopReading;
      setState(() {
        this.data = result;
      });
    }
    await cameraService.cameraController.stopImageStream();
  }

  route() async {
    await stopServices();
    UserService.getByCardNo(cardNo).then((value) {
      if (value != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserDetail(
                      cardNo: cardNo,
                      isInput: widget.isInput,
                    )));
      } else {
        ToastMessage.show("Kullanıcı Bulunamadı");
      }
    });
  }
}
