class BoundingBox {
  final double x;
  final double y;
  final double width;
  final double height;
  final String label;
  final double score;

  BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.label,
    required this.score,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      x: json['bbox'][0],
      y: json['bbox'][1],
      width: json['bbox'][2],
      height: json['bbox'][3],
      label: json['label'],
      score: json['score'],
    );
  }
}
