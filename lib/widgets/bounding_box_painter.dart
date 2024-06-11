import 'package:flutter/material.dart';

import '../models/bounding_box.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<BoundingBox> boundingBoxes;

  BoundingBoxPainter(this.boundingBoxes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var bbox in boundingBoxes) {
      final rect = Rect.fromLTWH(
        bbox.x * size.width / 800,
        bbox.y * size.height / 800,
        bbox.width * size.width / 800,
        bbox.height * size.height / 800,
      );
      canvas.drawRect(rect, paint);
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${bbox.label}: ${bbox.score.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.green, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(rect.left, rect.top - textPainter.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
