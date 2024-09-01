import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:identify_attendance_app/components/recognition.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 112;
  static const int HEIGHT = 112;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, Recognition> registered = {};

  @override
  String get modelName => 'assets/tflite_models/mobile_face_net.tflite';

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
    loadRegisteredFaces();
  }

  void loadRegisteredFaces() async {
    try {
      registered.clear();
      final snapshot = await _firestore.collection('student').get();
      for (var doc in snapshot.docs) {
        final name = doc['name'] as String;
        final embeddings =
            (doc['embedding'] as List).map((e) => e as double).toList();
        registered[name] = Recognition(Rect.zero, embeddings, 0);
      }
    } catch (e) {
      print('Error loading registered faces: $e');
    }
  }

  //
  // void registerFaceInDB(String name, List<double> embedding) async {
  //   try {
  //     await _firestore.collection('student').add({
  //       'name': name,
  //       'embeddings': embedding,
  //     });
  //     loadRegisteredFaces();
  //   } catch (e) {
  //     print('Error registering face in DB: $e');
  //   }
  // }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage =
        img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!
        .expand((channel) => [channel.r, channel.g, channel.b])
        .map((value) => value.toDouble())
        .toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) /
                  127.5;
        }
      }
    }
    return reshapedArray.reshape([1, 112, 112, 3]);
  }

  Recognition recognize(img.Image image, Rect location) {
    var input = imageToArray(image);
    print(input.shape.toString());

    List output = List.filled(1 * 192, 0).reshape([1, 192]);

    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    print('Time to run inference: $run ms$output');

    List<double> outputArray = output.first.cast<double>();

    Pair pair = findNearest(outputArray);
    print("distance= ${pair.distance}");

    return Recognition(location, outputArray, pair.distance);
  }

  Pair findNearest(List<double> emb) {
    Pair nearest = Pair("Unknown", double.infinity);
    for (MapEntry<String, Recognition> item in registered.entries) {
      final String name = item.key;
      List<double> knownEmb = item.value.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] - knownEmb[i];
        distance += diff * diff;
      }
      distance = sqrt(distance);
      if (distance < nearest.distance) {
        nearest.distance = distance;
        nearest.name = name;
      }
    }
    return nearest;
  }

  void close() {
    interpreter.close();
  }
}

class Pair {
  String name;
  double distance;

  Pair(this.name, this.distance);
}
