import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:identify_attendance_app/components/recognition.dart';
import 'package:identify_attendance_app/components/recognizer.dart';
import 'package:identify_attendance_app/screens/student_profile_page.dart';
import 'package:image/image.dart' as img;

import '../main.dart';
import 'alert_dialog_widget.dart';

class FaceCaptureWidget extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String matnumber;
  final String session;
  final String department;
  final String level;

  FaceCaptureWidget({
    Key? key,
    required this.email,
    required this.password,
    required this.name,
    required this.matnumber,
    required this.session,
    required this.department,
    required this.level,
  }) : super(key: key);

  @override
  _FaceCaptureWidget createState() => _FaceCaptureWidget();
}

class _FaceCaptureWidget extends State<FaceCaptureWidget> {
  bool showSpinner = false;
  CameraController? controller;
  bool isBusy = false;
  late Size size;
  late CameraDescription description = cameras[1];
  CameraLensDirection camDirec = CameraLensDirection.front;
  late List<Recognition> recognitions = [];

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //TODO declare face detector
  late FaceDetector dectector;

  //TODO declare face recognizer
  late Recognizer recognizer;

  @override
  void initState() {
    super.initState();

    //TODO initialize face detector
    dectector = FaceDetector(
        options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast));

    //TODO initialize face recognizer
    recognizer = Recognizer();

    //TODO initialize camera footage
    // description = cameras[1];
    initializeCamera();
  }

  //TODO code to initialize the camera feed
  initializeCamera() async {
    controller = CameraController(description, ResolutionPreset.high);
    try {
      await controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        controller!.startImageStream((image) => {
              if (!isBusy)
                {isBusy = true, frame = image, doFaceDetectionOnFrame()}
            });
        setState(() {});
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  //TODO close all resources
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  //TODO face detection on a frame
  dynamic _scanResults;
  CameraImage? frame;

  doFaceDetectionOnFrame() async {
    //TODO convert frame into InputImage format
    InputImage inputImage = getInputImage();
    //TODO pass InputImage to face detection model and detect faces
    List<Face> faces = await dectector.processImage(inputImage);
    for (Face face in faces) {
      print('Face Location' + face.boundingBox.toString());
    }
    //TODO perform face recognition on detected faces
    performFaceRecognition(faces);
    //
    // setState(() {
    //   _scanResults = faces;
    //   isBusy = false;
    // });
  }

  img.Image? image;
  bool register = false;

  // TODO perform Face Recognition
  performFaceRecognition(
    List<Face> faces,
  ) async {
    recognitions.clear();

    //TODO convert CameraImage to Image and rotate it so that our frame will be in a portrait
    image = convertYUV420ToImage(frame!);
    image = img.copyRotate(image!,
        angle: camDirec == CameraLensDirection.front ? 270 : 90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      //TODO crop face
      img.Image croppedFace = img.copyCrop(image!,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt());

      //TODO pass cropped face to face recognition model
      Recognition recognition =
          recognizer.recognize(croppedFace, face.boundingBox) as Recognition;
      if (recognition.distance > 1) {
        recognition.distance = 0.0;
      }
      recognitions.add(recognition);
      //TODO show face registration dialogue
      if (register) {
        showFaceRegistrationDialogue(croppedFace, recognition);
        register = false;
      }
    }

    setState(() {
      isBusy = false;
      _scanResults = recognitions;
    });
  }

  //this registers details in firestore
  void registerDetailsInFirestore(List<double> embedding) async {
    try {
      print('Creating user...');
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: widget.email, password: widget.password);
      print('User created: ${newUser.user?.uid}');
      if (newUser != null) {
        // Save additional user details to Firestore
        print('Creating Firestore document...');
        await _firestore.collection('student').doc(newUser.user!.uid).set({
          'name': widget.name,
          'matnumber': widget.matnumber,
          'session': widget.session,
          'department': widget.department,
          'level': widget.level,
          'embedding': embedding,
          // Add other fields as needed
        });
        print('Firestore document created');
        Navigator.pushNamed(context, StudentProfilePage.routeName);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialogWidget(
              message:
                  'Registration completed successfully. Proceed to profile',
              colour: Colors.indigoAccent,
              title: 'Registration Successful',
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'The email address is already in use by another account.';
          break;
        // You can add more cases for other error codes if needed
        default:
          errorMessage = 'An unexpected error occurred. Please try again.';
      }
      print('Error: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialogWidget(
            message: errorMessage,
            colour: Colors.redAccent,
            title: 'Registration Failed',
          );
        },
      );
    } catch (e) {
      print('Error: $e');
      //handle registration errors
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialogWidget(
              message: '$e',
              colour: Colors.redAccent,
              title: 'Registration Failed',
            );
          });
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
    recognizer.loadRegisteredFaces();
  }

  //TODO Face Registration Dialogue
  showFaceRegistrationDialogue(
    img.Image croppedFace,
    Recognition recognition,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.memory(
                Uint8List.fromList(img.encodeBmp(croppedFace!)),
                width: 200,
                height: 200,
              ),
              ElevatedButton(
                  onPressed: () async {
                    // setState(() {
                    //   showSpinner = true;
                    // });
                    registerDetailsInFirestore(recognition.embeddings);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.indigo, minimumSize: const Size(200, 40)),
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  // TODO method to convert CameraImage to Image
  img.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: width, height: height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final index = h * width + w;
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data!.setPixelR(w, h, yuv2rgb(y, u, v)); //= yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  //TODO convert CameraImage to InputImage
  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in frame!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(frame!.width.toDouble(), frame!.height.toDouble());
    final camera = description;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    // if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(frame!.format.raw);
    // if (inputImageFormat == null) return null;

    final planeData = frame!.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: frame!.planes[0].bytesPerRow,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, metadata: inputImageData);

    return inputImage;
  }

  // TODO Show rectangles around detected faces
  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller!.value.isInitialized) {
      return const Center(child: Text('Camera is not initialized'));
    }
    final Size imageSize = Size(
      controller!.value.previewSize!.height,
      controller!.value.previewSize!.width,
    );
    CustomPainter painter =
        FaceDetectorPainter(imageSize, _scanResults, camDirec);
    return CustomPaint(
      painter: painter,
    );
  }

  //TODO toggle camera direction
  void _toggleCameraDirection() async {
    if (camDirec == CameraLensDirection.back) {
      camDirec = CameraLensDirection.front;
      description = cameras[1];
    } else {
      camDirec = CameraLensDirection.back;
      description = cameras[0];
    }
    await controller!.stopImageStream();
    setState(() {
      controller;
    });

    initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null && controller!.value.isInitialized) {
      //TODO View for displaying the live camera footage
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: Container(
            child: (controller!.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: CameraPreview(controller!),
                  )
                : Container(),
          ),
        ),
      );

      //TODO View for displaying rectangles around detected aces
      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height,
            child: buildResult()),
      );
    }

    //TODO View for displaying the bar to switch camera direction or for registering faces
    stackChildren.add(Positioned(
      top: size.height - 140,
      left: 0,
      width: size.width,
      height: 80,
      child: Card(
        margin: const EdgeInsets.only(left: 20, right: 20),
        color: Colors.indigo,
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.cached,
                        color: Colors.white,
                      ),
                      iconSize: 40,
                      color: Colors.black,
                      onPressed: () {
                        _toggleCameraDirection();
                      },
                    ),
                    Container(
                      width: 30,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.face_retouching_natural,
                        color: Colors.white,
                      ),
                      iconSize: 40,
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          register = true;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            margin: const EdgeInsets.only(top: 0),
            color: Colors.black,
            child: Stack(
              children: stackChildren,
            )),
      ),
    );
  }
}

class InputImagePlaneMetadata {
  var bytesPerRow;
  var height;
  var width;

  InputImagePlaneMetadata({
    required this.bytesPerRow,
    this.height,
    this.width,
  });
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);

  final Size absoluteImageSize;
  final List<Recognition> faces;
  CameraLensDirection camDire2;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.indigoAccent;

    for (Recognition face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          camDire2 == CameraLensDirection.front
              ? (absoluteImageSize.width - face.location.right) * scaleX
              : face.location.left * scaleX,
          face.location.top * scaleY,
          camDire2 == CameraLensDirection.front
              ? (absoluteImageSize.width - face.location.left) * scaleX
              : face.location.right * scaleX,
          face.location.bottom * scaleY,
        ),
        paint,
      );

      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 20),
          text: "${face.distance.toStringAsFixed(2)}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas,
          Offset(face.location.left * scaleX, face.location.top * scaleY));
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return true;
  }
}
