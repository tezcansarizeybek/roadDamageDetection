import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

import '../controllers/camera_view_model.dart';
import '../widgets/bounding_box_painter.dart';

class ResultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CameraViewModel _cameraViewModel = Get.find();

    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: Obx(() {
        if (_cameraViewModel.resizedImage.value != null) {
          return Stack(
            children: [
              Image.memory(
                Uint8List.fromList(
                    img.encodeJpg(_cameraViewModel.resizedImage.value!)),
                width: 800,
                height: 800,
                fit: BoxFit.cover,
              ),
              CustomPaint(
                painter: BoundingBoxPainter(_cameraViewModel.boundingBoxes),
                child: Container(
                  width: 800,
                  height: 800,
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text("No image selected"));
        }
      }),
    );
  }
}
