import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/camera_view_model.dart';
import 'result_view.dart';

class CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CameraViewModel _cameraViewModel = Get.put(CameraViewModel());

    return Scaffold(
      appBar: AppBar(title: Text('Select Image')),
      body: Obx(() {
        if (_cameraViewModel.isProcessing.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _cameraViewModel.pickImage(ImageSource.camera);
                    Get.to(() => ResultView());
                  },
                  child: Text("Take Photo"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _cameraViewModel.pickImage(ImageSource.gallery);
                    Get.to(() => ResultView());
                  },
                  child: Text("Select from Gallery"),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
