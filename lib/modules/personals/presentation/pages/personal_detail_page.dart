import 'package:flutter/material.dart';
import '../../data/models/personal_model.dart';

class PersonalDetailPage extends StatelessWidget {
  final PersonalModel personal;

  const PersonalDetailPage({super.key, required this.personal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(personal.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(personal.photoUrl),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                personal.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${personal.rating} ⭐',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Especialidades:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: personal.specialties
                  .map((e) => Chip(label: Text(e)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Localização:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('${personal.city} - ${personal.state}'),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Aqui você pode abrir um modal ou navegar para outra tela
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Simulação de contato iniciada!')),
                  );
                },
                icon: const Icon(Icons.message),
                label: const Text('Entrar em contato'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}