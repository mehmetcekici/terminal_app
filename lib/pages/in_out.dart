import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:nfc_io/nfc_io.dart';
import 'package:terminal_app/main.dart';
import 'package:terminal_app/pages/user_detail.dart';
import 'package:terminal_app/services/device/nfc_service.dart';
import 'package:terminal_app/services/web/user_service.dart';
import 'package:terminal_app/services/device/camera.service.dart';
import 'package:terminal_app/utils/convert.dart';
import 'package:terminal_app/utils/face_comparison.dart';
import 'package:terminal_app/services/device/toast_service.dart';
import 'package:terminal_app/widgets/circular_progress.dart';
import 'package:terminal_app/widgets/info.dart';

class InOut extends StatefulWidget {
  final isInput;
  InOut({Key key, this.isInput}) : super(key: key);

  @override
  _InOutState createState() => _InOutState();
}

class _InOutState extends State<InOut> {
  CameraService cameraService = CameraService();
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
  FaceComparison faceService = FaceComparison();
  bool detectingFaces = false;
  Future cameraFuture;
  Face face;
  Size imageSize;
  bool load = false;

  NfcData data;
  @override
  void initState() {
    super.initState();
    startServices();
  }

  @override
  void dispose() {
    stopServices();
    cameraService.cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          load
              ? cameraService.camView(context, cameraFuture, face, imageSize)
              : CircularProgress(),
          Positioned(
            top: 0,
            child: CustomInfo(
              cam: cameraFuture != null,
              nfc: NfcService.isStarting,
            ),
          ),
        ],
      ),
    );
  }

  startServices() async {
    NfcService.start(onRead);
    Future.delayed(Duration(milliseconds: 500));
    cameraFuture = cameraService.startService(MyApp.state.cameraDescription);
    await cameraFuture;
    setState(() {
      load = true;
    });
    faceDedect();
  }

  stopServices() async {
    NfcService.stop();
    await cameraService.cameraController.stopImageStream();
  }

  onRead(data) {
    setState(() {
      this.data = data;
      var cardNo = Convert.hextoDecimal(data.id);
      UserService.getByCardNo(cardNo).then((value) {
        navigate(value.id);
      });
    });
  }

  faceDedect() {
    imageSize = cameraService.getImageSize();
    cameraService.cameraController.startImageStream((image) async {
      if (cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (detectingFaces) return;

        detectingFaces = true;

        try {
          var inputImage =
              cameraService.toInputImage(image, cameraService.cameraRotation);
          List<Face> faces = await faceDetector.processImage(inputImage);
          if (faces != null) {
            if (faces.length > 0) {
              setState(() {
                face = faces[0];
              });
              if (isMiddle) {
                await Future.delayed(Duration(milliseconds: 500));
                setState(() {
                  load = false;
                });
                await Future.delayed(Duration(milliseconds: 200));
                await faceService.setCurrentFace(image, face);
                int userId = await faceService.searchResult();
                faceService.clearFacedata();
                if (userId != null) {
                  navigate(userId);
                } else {
                  setState(() {
                    load = true;
                  });
                }
              }
            } else {
              setState(() {
                face = null;
                load = true;
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

  get isMiddle {
    if (imageSize == null || face == null) return false;
    var left =
        (imageSize.width - face.boundingBox.right) > imageSize.width / 10;
    var right = face.boundingBox.left > imageSize.width / 10;
    var bottom =
        (imageSize.height - face.boundingBox.bottom) > imageSize.height / 5;
    var top = face.boundingBox.top > imageSize.height / 5;
    return left && right && bottom && top;
  }

  navigate(int userId) async {
    await stopServices();
    UserService.getById(userId).then((value) {
      if (value != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserDetail(
                      id: userId,
                      isInput: widget.isInput,
                    )));
      } else {
        ToastService.show("Kullanıcı Bulunamadı");
      }
    });
  }
}
