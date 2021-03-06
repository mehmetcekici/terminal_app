import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:terminal_app/main.dart';
import 'package:terminal_app/services/web/user_service.dart';
import 'package:terminal_app/services/device/camera.service.dart';
import 'package:terminal_app/utils/face_comparison.dart';

class FaceRegister extends StatefulWidget {
  final id;
  FaceRegister({Key key, this.id}) : super(key: key);

  @override
  _FaceRegisterState createState() => _FaceRegisterState();
}

class _FaceRegisterState extends State<FaceRegister> {
  CameraService cameraService = CameraService();
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
  FaceComparison faceService = FaceComparison();
  bool detectingFaces = false;
  Future cameraFuture;
  Face face;
  Size imageSize;
  bool load = false;

  @override
  void initState() {
    super.initState();
    startCam();
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
        alignment: Alignment.center,
        children: [
          cameraService.camView(
            context,
            cameraFuture,
            face,
            imageSize,
          ),
          load ? CircularProgressIndicator() : Center(),
        ],
      ),
    );
  }

  startCam() async {
    cameraFuture = cameraService.startService(MyApp.state.cameraDescription);
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
          var inputImage = cameraService.toInputImage(
            image,
            cameraService.cameraRotation,
          );
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
                await cameraService.cameraController.stopImageStream();
                await Future.delayed(Duration(milliseconds: 200));
                await faceService.setCurrentFace(image, face);
                var user = await UserService.getById(widget.id);
                user.face = faceService.faceData;
                faceService.clearFacedata();
                var result = await UserService.update(user);
                if (result != null) {
                  Navigator.pop(context);
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
}
