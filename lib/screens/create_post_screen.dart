import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../providers/auth_provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _postService = PostService();
  
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;

  // Seleccionar imagen usando image_picker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  // Subir imagen y guardar publicación en Firestore
  Future<void> _submitPost() async {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa los campos de título y contenido')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String imageUrl = '';
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.uid ?? 'anonimo';

      // Si seleccionó imagen, la subimos a Firebase Storage[cite: 7]
      if (_selectedImageBytes != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$userId';
        imageUrl = await _postService.uploadImageBytes(_selectedImageBytes!, fileName);
      }

      final newPost = Post(
        id: '',
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        imageUrl: imageUrl,
        authorId: userId,
        createdAt: DateTime.now(),
        likes: [],
      );

      await _postService.createPost(newPost);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear publicación: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Publicación'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: '¿Qué está haciendo tu mascota?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Vista previa de la imagen seleccionada
            if (_selectedImageBytes != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  _selectedImageBytes!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
            ],

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: Text(_selectedImageBytes == null ? 'Seleccionar Imagen' : 'Cambiar Imagen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Publicar', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}