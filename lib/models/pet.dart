class Pet {
  final String id;
  final String name;
  final String type; // e.g., 'perro', 'gato'
  final String breed;
  final int age;
  final double weight;
  final List<String> photos;
  final String bio;
  final String ownerId;
  final bool isForAdoption;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.weight,
    required this.photos,
    required this.bio,
    required this.ownerId,
    this.isForAdoption = false,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'type': type,
        'breed': breed,
        'age': age,
        'weight': weight,
        'photos': photos,
        'bio': bio,
        'ownerId': ownerId,
        'isForAdoption': isForAdoption,
      };

  factory Pet.fromMap(String id, Map<String, dynamic> map) => Pet(
        id: id,
        name: map['name'] ?? '',
        type: map['type'] ?? '',
        breed: map['breed'] ?? '',
        age: map['age'] ?? 0,
        weight: (map['weight'] ?? 0.0).toDouble(),
        photos: List<String>.from(map['photos'] ?? []),
        bio: map['bio'] ?? '',
        ownerId: map['ownerId'] ?? '',
        isForAdoption: map['isForAdoption'] ?? false,
      );
}