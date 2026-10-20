import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';

class PetService {
  final _collection = FirebaseFirestore.instance.collection('pets');

  // Registrar una nueva mascota (PV3)[cite: 15, 16]
  Future<void> registerPet(Pet pet) async {
    await _collection.add(pet.toMap());
  }

  // Obtener stream de mascotas en adopción (PV7)
  Stream<List<Pet>> getAdoptionPets() {
    return _collection
        .where('isForAdoption', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Pet.fromMap(doc.id, doc.data()))
            .toList());
  }
}