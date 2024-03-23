class Tag {
  const Tag({
    required this.name,
  });

  final String name;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'],
    );
  }
}
