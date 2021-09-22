import 'package:flutter/material.dart';
import 'package:mnist_predictor_app/df_model/classifier.dart';

class DrawingPage extends StatefulWidget {
  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  int digit = -1;
  Classifier classifier = Classifier();

  List<Offset> points = List<Offset>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.close),
        onPressed: () {
          points.clear();
          digit = -1;
          setState(() {});
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Draw and Predict'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40.0),
            Text(
              "Draw Here!",
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
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 3.0),
                // image: DecorationImage(
                //     image: digit == -1
                //         ? AssetImage("assets/white_background.jpeg")
                //         : FileImage(File(image.path)),
                //     fit: BoxFit.fill)
              ),
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  Offset localPosition = details.localPosition;
                  setState(() {
                    if (localPosition.dx >= 0 &&
                        localPosition.dx <= 300 &&
                        localPosition.dy >= 0 &&
                        localPosition.dy <= 300) {
                      setState(() {
                        points.add(localPosition);
                      });
                    }
                  });
                },
                onPanEnd: (DragEndDetails details) async {
                  points.add(null);
                  digit = await classifier.classifyDrawing(points);
                  setState(() {});
                },
                child: CustomPaint(
                  painter: Painter(points: points),
                ),
              ),
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

class Painter extends CustomPainter {
  final List<Offset> points;
  Painter({this.points});

  final Paint _paintDetails = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth =
        4.0 // strokeWidth 4 looks good, but strokeWidth approx. 16 looks closer to training data
    ..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], _paintDetails);
      }
    }
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return true;
  }
}
