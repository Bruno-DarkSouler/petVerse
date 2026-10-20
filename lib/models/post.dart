class Post {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String authorId;
  final DateTime createdAt;
  List<String> likes;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.authorId,
    required this.createdAt,
    required this.likes,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'authorId': authorId,
        'createdAt': createdAt.toIso8601String(),
        'likes': likes, // Incluido para persistir los likes en Firestore
      };

  factory Post.fromMap(String id, Map<String, dynamic> map) => Post(
        id: id,
        title: map['title'] ?? '',
        content: map['content'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        authorId: map['authorId'] ?? '',
        createdAt: map['createdAt'] != null 
            ? DateTime.parse(map['createdAt']) 
            : DateTime.now(),
        // Conversión segura de la lista de likes proveniente de Firestore
        likes: List<String>.from(map['likes'] ?? []),
      );
}