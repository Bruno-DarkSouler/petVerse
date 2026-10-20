import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/post_service.dart';
import '../providers/auth_provider.dart';

class LikeButton extends StatelessWidget {
  final String postId;
  final List<dynamic> likes;

  const LikeButton({
    super.key,
    required this.postId,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.uid ?? '';
    final hasLiked = likes.contains(userId);
    final postService = PostService();

    return Row(
      children: [
        IconButton(
          icon: Icon(
            hasLiked ? Icons.favorite : Icons.favorite_border,
            color: hasLiked ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            if (userId.isEmpty) return;
            // Ejecuta la actualización atómica de likes en Firestore[cite: 6]
            postService.toggleLike(postId, userId, likes);
          },
        ),
        Text(
          '${likes.length}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }
}