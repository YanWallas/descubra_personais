import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/personal_entity.dart';
import 'hiring_simulation_page.dart';

class PersonalDetailPage extends StatelessWidget {
  final PersonalEntity personal;

  const PersonalDetailPage({super.key, required this.personal});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/55${personal.whatsapp}');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(personal.name),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(radius: 60, backgroundImage: NetworkImage(personal.photoUrl)),
                        const SizedBox(height: 16),
                        Text(
                          personal.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          backgroundColor: Colors.amber.shade100,
                          avatar: Icon(Icons.star, color: Colors.amber.shade800, size: 18),
                          label: Text(
                            personal.rating.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionTitle(context, 'Sobre'),
                  Text(personal.bio, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87)),
                  const SizedBox(height: 24),

                  _buildSectionTitle(context, 'Especialidades'),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: personal.specialties.map((e) => Chip(label: Text(e))).toList(),
                  ),
                  const SizedBox(height: 24),

                  _buildInfoRow(context, Icons.location_on, '${personal.city}, ${personal.state}'),
                  const SizedBox(height: 12),
                  _buildInfoRow(context, Icons.attach_money, 'A partir de R\$ ${personal.price.toStringAsFixed(2)} / aula'),
                ],
              ),
            ),
          ),
          _buildBottomActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
  
  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 12),
        Text(text, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildBottomActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(top: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -5)),
        ],
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.message_outlined),
              label: const Text('WhatsApp'),
              onPressed: () => _launchWhatsApp(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HiringSimulationPage(personal: personal)),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Quero Contratar'),
            ),
          ),
        ],
      ),
    );
  }
}