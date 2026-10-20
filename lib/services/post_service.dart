import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/comment.dart';
import '../models/post.dart';

class PostService {
  final _collection = FirebaseFirestore.instance.collection('posts');
  final _storage = FirebaseStorage.instance;

  // Método para subir imágenes en Web usando Uint8List[cite: 7]
  Future<String> uploadImageBytes(Uint8List bytes, String fileName) async {
    final ref = _storage.ref().child('posts/$fileName.jpg');
    final uploadTask = ref.putData(bytes);

    // Escuchar el progreso de subida[cite: 7]
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      print('Progreso de subida: ${(progress * 100).toStringAsFixed(1)}%');
    });

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Crear documento de publicación en Firestore[cite: 6]
  Future<void> createPost(Post post) async {
    await _collection.add(post.toMap());
  }

  // Stream para obtener publicaciones en tiempo real[cite: 6, 14]
  Stream<List<Post>> getPosts() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> toggleLike(String postId, String userId, List<dynamic> currentLikes) async {
    final postRef = _collection.doc(postId);
    
    if (currentLikes.contains(userId)) {
      // Si ya dio like, lo removemos
      await postRef.update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      // Si no ha dado like, lo agregamos de forma atómica[cite: 6]
      await postRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(comment.toMap());
  }

  // Obtener stream de comentarios en tiempo real para una publicación
  Stream<List<Comment>> getComments(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Eliminar un comentario
  Future<void> deleteComment(String postId, String commentId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}