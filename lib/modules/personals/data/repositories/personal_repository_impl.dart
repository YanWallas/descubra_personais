import '../../domain/entities/personal_entity.dart';
import '../../domain/repositories/personal_repository.dart';
import '../datasources/personal_remote_datasource.dart';

class PersonalRepositoryImpl implements PersonalRepository {
  final PersonalRemoteDatasource datasource;

  PersonalRepositoryImpl({required this.datasource});

  @override
  Future<List<PersonalEntity>> getPersonals() async {
    final personalModels = await datasource.getPersonals();
    return personalModels;
  }

  @override
  Future<bool> sendContactInterest({
    required String personalId,
    required String modality,
    required String frequency,
    required double estimatedPrice,
  }) async {
    return await datasource.sendContactInterest(
      personalId: personalId,
      modality: modality,
      frequency: frequency,
      estimatedPrice: estimatedPrice,
    );
  }
}