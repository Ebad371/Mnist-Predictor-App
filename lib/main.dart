import 'package:flutter/material.dart';
import 'package:mnist_predictor_app/pages/upload_page.dart';
import 'package:mnist_predictor_app/pages/drawing_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List tabs = [UploadImage(), DrawingPage()];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[400],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image'),
          BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Draw')
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    ));
  }
}
