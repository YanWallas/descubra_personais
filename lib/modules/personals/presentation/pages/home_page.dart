import 'package:flutter/material.dart';
import '../../data/datasources/personal_remote_datasource.dart';
import '../../data/models/personal_model.dart';
import './personal_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final datasource = PersonalRemoteDatasource();
  late Future<List<PersonalModel>> personalsFuture;

  @override
  void initState() {
    super.initState();
    personalsFuture = datasource.getPersonals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personais'),
      ),
      body: FutureBuilder<List<PersonalModel>>(
        future: personalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum personal encontrado.'));
          }

          final personals = snapshot.data!;

          return ListView.builder(
            itemCount: personals.length,
            itemBuilder: (context, index) {
              final p = personals[index];
              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(p.photoUrl)),
                title: Text(p.name),
                subtitle: Text('${p.specialties.join(', ')}\n${p.city} - ${p.state}'),
                trailing: Text('${p.rating} ⭐'),
                isThreeLine: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalDetailPage(personal: p),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}