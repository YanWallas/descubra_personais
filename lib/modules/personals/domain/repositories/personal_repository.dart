import '../entities/personal_entity.dart';

abstract class PersonalRepository {
  Future<List<PersonalEntity>> getPersonals();

  Future<bool> sendContactInterest({
    required String personalId,
    required String modality,
    required String frequency,
    required double estimatedPrice,
  });
}