import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_mediapipe/flutter_mediapipe.dart';
import 'package:flutter_mediapipe/gen/landmark.pb.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double count = 0.0;
  double deviceAngle = 0.0;

  @override
  void initState() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        // valueX = (event.x * 1000).toInt() / 100;
        // valueY = (event.y * 1000).toInt() / 100;
        // valueZ = (event.z * 1000).toInt() / 100;
        deviceAngle = (event.z * 1000).toInt() / 100;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Mediapipe'),
        ),
        body: Stack(
          children: [
            Positioned(
              child: NativeView(
                onViewCreated: (FlutterMediapipe c) => setState(
                  () {
                    c.landMarksStream.listen(_onLandMarkStream);
                    c.platformVersion.then((content) => print(content));
                  },
                ),
              ),
            ),
            Positioned(
              child: Text(
                "$count\n$deviceAngle",
                style: TextStyle(color: Colors.red, fontSize: 35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLandMarkStream(NormalizedLandmarkList landmarkList) {
    //   landmarkList.landmark.asMap().forEach((int i, NormalizedLandmark value) {
    //    // print('Index: $i \n' + '$value');
    //   });

    //   print("8번 x");
    //   print(landmarkList.landmark.asMap()[8]!.x);
    //   print("8번 y");
    //   print(landmarkList.landmark.asMap()[8]!.y);
    //   print("8번 z");
    //   print(landmarkList.landmark.asMap()[8]!.z);
    //   print(" ");

    //   print("18번 x");
    //   print(landmarkList.landmark.asMap()[18]!.x);
    //   print("18번 y");
    //   print(landmarkList.landmark.asMap()[18]!.y);
    //   print("18번 z");
    //   print(landmarkList.landmark.asMap()[18]!.z);
    //   print(" ");
    double xCal = landmarkList.landmark.asMap()[133]!.x -
        landmarkList.landmark.asMap()[33]!.x;
    double yCal = landmarkList.landmark.asMap()[145]!.y -
        landmarkList.landmark.asMap()[159]!.y;   
    double yyCal = yCal*yCal;
    double result = calculateDegree(a: yCal, b: xCal);

    count = result;

    print(result);
  }

  /// ### tan(a/b)로 사용
  ///  - a: 분자
  ///  - b: 분모
  double calculateDegree({
    required double a,
    required double b,
  }) {
   
    double degree = a  / b / math.pi; // (세로/가로) * 100

    return degree;
  }
  
}