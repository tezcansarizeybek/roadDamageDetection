import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/camera_view.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: ThemeData.dark(),
      home: CameraView(),
    ),
  );
}
