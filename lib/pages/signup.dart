import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:terminal_app/utils/camera.service.dart';
import 'package:terminal_app/utils/convert.dart';
import 'package:terminal_app/widgets/camera_footer.dart';
import 'package:terminal_app/widgets/camera_header.dart';

class SignUp extends StatefulWidget {
  final CameraDescription cameraDescription;
  final isInput;
  SignUp({Key key, this.cameraDescription, this.isInput}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  CameraService cameraService = CameraService();
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
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
    cameraFuture = cameraService.startService(widget.cameraDescription);
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
                await cameraService.cameraController.stopImageStream();
                await Future.delayed(Duration(milliseconds: 200));
                //XFile file = await cameraService.takePicture();
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
