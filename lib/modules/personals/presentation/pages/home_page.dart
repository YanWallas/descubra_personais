// lib/modules/personals/presentation/pages/home_page.dart
import 'package:flutter/material.dart';

import '../../data/datasources/personal_remote_datasource.dart';
import '../../data/repositories/personal_repository_impl.dart';
import '../../domain/entities/personal_entity.dart';
import '../../domain/repositories/personal_repository.dart';
import 'personal_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PersonalRepository repository;
  late Future<List<PersonalEntity>> personalsFuture;

  @override
  void initState() {
    super.initState();
    repository = PersonalRepositoryImpl(datasource: PersonalRemoteDatasource());
    personalsFuture = repository.getPersonals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubra Personais'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<PersonalEntity>>( // Usamos a Entidade aqui!
        future: personalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum personal encontrado.'));
          }

          final personals = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: personals.length,
            itemBuilder: (context, index) {
              final personal = personals[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(personal.photoUrl),
                  ),
                  title: Text(personal.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${personal.specialties.join(', ')}\n${personal.city} - ${personal.state}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(personal.rating.toString(), style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalDetailPage(personal: personal),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}