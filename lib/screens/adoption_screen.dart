import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class AdoptionScreen extends StatelessWidget {
  AdoptionScreen({super.key});

  final PetService _petService = PetService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas en Adopción'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Pet>>(
        stream: _petService.getAdoptionPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay mascotas buscando hogar en este momento.'),
            );
          }

          final pets = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columnas para diseño responsivo web/móvil
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: pet.photos.isNotEmpty
                            ? Image.network(
                                pet.photos.first,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.pets, size: 50),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text('${pet.breed} • ${pet.age} años'),
                          const SizedBox(height: 4),
                          Text(
                            pet.bio,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}