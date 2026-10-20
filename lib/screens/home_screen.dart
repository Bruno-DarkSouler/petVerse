import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetVerse - Feed'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      // StreamBuilder para escuchar publicaciones en tiempo real[cite: 14]
      body: StreamBuilder<List<Post>>(
        stream: _postService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay publicaciones aún. ¡Sé el primero en publicar!'),
            );
          }

          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, i) => PostCard(post: posts[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí navegaremos a la pantalla de crear post en la siguiente fase
          Navigator.pushNamed(context, '/new-post');
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}