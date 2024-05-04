class User {
  final String id;
  final String username;
  final String? userProfileImagePath;

  User({required this.id, required this.username, this.userProfileImagePath});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        userProfileImagePath: json['userProfileImagePath']);
  }
}
