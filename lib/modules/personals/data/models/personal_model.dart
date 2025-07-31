import '../../domain/entities/personal_entity.dart';

class PersonalModel extends PersonalEntity {
  PersonalModel({
    required super.id,
    required super.name,
    required super.bio,
    required super.specialties,
    required super.rating,
    required super.city,
    required super.state,
    required super.photoUrl,
    required super.whatsapp,
    required super.price,
  });

  factory PersonalModel.fromJson(Map<String, dynamic> json) {
    return PersonalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      specialties: List<String>.from(json['specialties']),
      rating: (json['rating'] as num).toDouble(),
      city: json['city'] as String,
      state: json['state'] as String,
      photoUrl: json['photoUrl'] as String,
      whatsapp: json['whatsapp'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}
