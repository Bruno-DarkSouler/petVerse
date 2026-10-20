class Comment {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userName': userName,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Comment.fromMap(String id, Map<String, dynamic> map) => Comment(
        id: id,
        userId: map['userId'] ?? '',
        userName: map['userName'] ?? '',
        text: map['text'] ?? '',
        createdAt: map['createdAt'] != null
            ? DateTime.parse(map['createdAt'])
            : DateTime.now(),
      );
}