import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io' as io;
import 'package:image/image.dart' as img;

class Classifier {
  Classifier();

  classifyImage(PickedFile image) async {
    io.File file = io.File(image.path);
    img.Image imageTemp = img.decodeImage(file.readAsBytesSync());
    img.Image resizedImage = img.copyResize(imageTemp, height: 28, width: 28);
    var imgBytes = resizedImage.getBytes();
    var imgAsList = imgBytes.buffer.asUint8List();

    return getPred(imgAsList);
  }

  classifyDrawing(List<Offset> points) async {
    // Takes img as a List of Points from Drawing and returns Integer
    // of which digit it was (hopefully)!

    // Ugly boilerplate to get it to Uint8List
    final picture = toPicture(points); // convert List to Picture
    final image = await picture.toImage(28, 28); // Picture to 28x28 Image
    ByteData imgBytes = await image.toByteData(); // Read this image
    var imgAsList = imgBytes.buffer.asUint8List();

    // Everything "important" is done in getPred
    return getPred(imgAsList);
  }

  Future<int> getPred(Uint8List imgAsList) async {
    List resultBytes = List(28 * 28);

    //convert to grey scale

    int index = 0;
    for (int i = 0; i < imgAsList.lengthInBytes; i += 4) {
      final r = imgAsList[i];
      final g = imgAsList[i + 1];
      final b = imgAsList[i + 2];

      resultBytes[index] = ((r + g + b / 3.0) / 255.0);
      index++;
    }

    var input = resultBytes
        .reshape([1, 28, 28, 1]); //first 1 is because there is only 1 image
    var output = List(1 * 10).reshape([1, 10]);

    InterpreterOptions interpreterOptions = InterpreterOptions();

    try {
      Interpreter interpreter = await Interpreter.fromAsset("model_new.tflite",
          options: interpreterOptions);
      interpreter.run(input, output);
    } catch (e) {
      print("Error Loading Model");
    }

    double highestProb = 0;
    int digitPred;
    //output -> 1x10 hence take 0th index
    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > highestProb) {
        highestProb = output[0][i];
        digitPred = i;
      }
    }
    return digitPred;
  }
}

ui.Picture toPicture(List<Offset> points) {
  // Obtain a Picture from a List of points
  // This Picture can then be converted to something
  // we can send to our model. Seems unnecessary to draw twice,
  // but couldn't find a way to record while using CustomPainter,
  // this is a future improvement to make.

  final _whitePaint = Paint()
    ..strokeCap = StrokeCap.round
    ..color = Colors.white
    ..strokeWidth = 16.0;

  final _bgPaint = Paint()..color = Colors.black;
  final _canvasCullRect =
      Rect.fromPoints(Offset(0, 0), Offset(28.toDouble(), 28.toDouble()));
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, _canvasCullRect)..scale(28 / 300);

  canvas.drawRect(Rect.fromLTWH(0, 0, 28, 28), _bgPaint);

  for (int i = 0; i < points.length - 1; i++) {
    if (points[i] != null && points[i + 1] != null) {
      canvas.drawLine(points[i], points[i + 1], _whitePaint);
    }
  }

  return recorder.endRecording();
}
