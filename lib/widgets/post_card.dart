import 'package:flutter/material.dart';
import 'like_button.dart';
import 'comment_section.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera del post (Autor)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.deepOrangeAccent,
                  child: Icon(Icons.pets, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  'Usuario: ${post.authorId.substring(0, 6)}...',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Imagen de la publicación
          if (post.imageUrl.isNotEmpty)
            Image.network(
              post.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

          // Título y contenido
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(post.content),
                // Dentro del Column de tu PostCard, bajo la imagen o el contenido:
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    children: [
                      LikeButton(postId: post.id, likes: post.likes), // Requerimiento PV5[cite: 16]
                      const SizedBox(width: 24),
                      
                      // Botón de comentarios interactivo (Requerimiento PV6)[cite: 5, 16]
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true, // Permite que el modal se adapte al teclado al escribir
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (context) => Padding(
                              // Evita que el teclado tape el campo de texto del comentario
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: CommentSection(postId: post.id),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.comment_outlined, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              'Comentarios',
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Dentro del build de tu PostCard:
          
        ],
      ),
    );
  }
}