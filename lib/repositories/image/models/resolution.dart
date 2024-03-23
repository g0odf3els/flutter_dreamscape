class Resolution {
  const Resolution({
    required this.width,
    required this.height,
  });

  final int width;
  final int height;

  factory Resolution.fromJson(Map<String, dynamic> json) {
    return Resolution(
      width: json['width'],
      height: json['height'],
    );
  }
}
