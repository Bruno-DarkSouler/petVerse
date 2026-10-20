import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/comment.dart';
import '../services/post_service.dart';
import '../providers/auth_provider.dart';

class CommentSection extends StatefulWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _commentController = TextEditingController();
  final _postService = PostService();

  void _sendComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    final newComment = Comment(
      id: '',
      userId: user?.uid ?? 'anonimo',
      userName: user?.email ?? 'Usuario PetVerse',
      text: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    await _postService.addComment(widget.postId, newComment);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      child: Column(
        children: [
          const Text(
            'Comentarios',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: _postService.getComments(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Sé el primero en comentar.'));
                }

                final comments = snapshot.data!;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person, size: 20),
                      ),
                      title: Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text(comment.text),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un comentario...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.deepOrange),
                onPressed: _sendComment,
              ),
            ],
          ),
        ],
      ),
    );
  }
}