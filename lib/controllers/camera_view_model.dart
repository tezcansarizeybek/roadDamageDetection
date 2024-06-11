import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/bounding_box.dart';

class CameraViewModel extends GetxController {
  final ImagePicker _picker = ImagePicker();
  RxList<BoundingBox> boundingBoxes = <BoundingBox>[].obs;
  RxBool isProcessing = false.obs;
  RxString selectedImagePath = ''.obs;
  Rx<img.Image?> resizedImage = Rx<img.Image?>(null);

  Future<void> pickImage(ImageSource source) async {
    isProcessing.value = true;
    try {
      if (await _requestPermission(Permission.storage)) {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          selectedImagePath.value = image.path;
          Uint8List jpegBytes = await convertImageToJpeg(image.path);
          resizedImage.value = resizeImage(jpegBytes, 800, 800);
          await sendFrameToAPI(
              Uint8List.fromList(img.encodeJpg(resizedImage.value!)));
        }
      } else {
        print("Storage permission denied");
      }
    } finally {
      isProcessing.value = false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }

  Future<Uint8List> convertImageToJpeg(String filePath) async {
    File file = File(filePath);
    Uint8List bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception("Failed to decode image");
    return Uint8List.fromList(img.encodeJpg(image));
  }

  img.Image resizeImage(Uint8List jpegBytes, int width, int height) {
    img.Image image = img.decodeImage(jpegBytes)!;
    return img.copyResize(image, width: width, height: height);
  }

  Future<void> sendFrameToAPI(Uint8List jpegBytes) async {
    final url = Uri.parse("http://10.20.28.96:5000/predict");
    final request = http.MultipartRequest('POST', url)
      ..files.add(http.MultipartFile.fromBytes('file', jpegBytes,
          filename: 'frame.jpg'));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(responseBody);
      boundingBoxes.value =
          jsonResponse.map((data) => BoundingBox.fromJson(data)).toList();
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}
