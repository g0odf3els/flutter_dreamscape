class ImageColor {
  const ImageColor({
    required this.a,
    required this.r,
    required this.g,
    required this.b,
  });

  final int a;
  final int r;
  final int g;
  final int b;

  factory ImageColor.fromJson(Map<String, dynamic> json) {
    return ImageColor(
      a: json['a'],
      r: json['r'],
      g: json['g'],
      b: json['b'],
    );
  }
}
