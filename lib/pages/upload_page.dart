import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mnist_predictor_app/df_model/classifier.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final picker = ImagePicker();
  PickedFile image;
  int digit = -1;
  Classifier classifier = Classifier();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.camera_alt_outlined),
        onPressed: () async {
          image = await picker.getImage(
              source: ImageSource.camera,
              maxHeight: 300,
              maxWidth: 300,
              imageQuality: 100);
          print(image);

          digit = await classifier.classifyImage(image);

          setState(() {});
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Number Predictor'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40.0),
            Text(
              "The Uploaded Image Will Come Here!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black, width: 3.0),
                  image: DecorationImage(
                      image: digit == -1
                          ? AssetImage("assets/white.jpeg")
                          : FileImage(File(image.path)),
                      fit: BoxFit.fill)),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Current Prediction',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              digit == -1 ? "" : "$digit",
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w900,
              ),
            )
          ],
        ),
      ),
    );
  }
}
