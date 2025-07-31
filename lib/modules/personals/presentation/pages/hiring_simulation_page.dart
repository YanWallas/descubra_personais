import 'package:flutter/material.dart';
import 'dart:async';

import '../../domain/entities/personal_entity.dart';

class HiringSimulationPage extends StatefulWidget {
  final PersonalEntity personal;

  const HiringSimulationPage({super.key, required this.personal});

  @override
  State<HiringSimulationPage> createState() => _HiringSimulationPageState();
}

class _HiringSimulationPageState extends State<HiringSimulationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedModality;
  String? _selectedFrequency;
  double _estimatedPrice = 0.0;
  bool _isLoading = false;

  final List<String> _modalities = ['Online', 'Presencial'];
  final Map<String, int> _frequencies = {
    '1x por semana': 4,
    '2x por semana': 8,
    '3x por semana': 12,
  };

  void _calculatePrice() {
    if (_selectedFrequency != null) {
      final basePrice = widget.personal.price;
      final frequencyMultiplier = _frequencies[_selectedFrequency]!;
      setState(() {
        _estimatedPrice = basePrice * frequencyMultiplier;
      });
    }
  }

  // Simular função de envio de interesse
  Future<void> _submitInterest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // SIMULAÇÃO: Espera 2 segundos para parecer uma chamada de rede
    await Future.delayed(const Duration(seconds: 2));

    // Desativa o loading (verificando se a tela ainda existe)
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Mostra a mensagem ficticia de sucesso
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('🎉 Interesse Enviado!'),
        content: Text(
          'Seu interesse em contratar ${widget.personal.name} foi registrado com sucesso. Em breve ele(a) entrará em contato.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Ótimo!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contratar ${widget.personal.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Simule sua contratação',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedModality,
                decoration: const InputDecoration(labelText: 'Modalidade', border: OutlineInputBorder()),
                items: _modalities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _selectedModality = v),
                validator: (v) => v == null ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: const InputDecoration(labelText: 'Frequência', border: OutlineInputBorder()),
                items: _frequencies.keys.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) {
                  setState(() => _selectedFrequency = v);
                  _calculatePrice();
                },
                validator: (v) => v == null ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 32),
              if (_estimatedPrice > 0)
                Center(
                  child: Column(
                    children: [
                      Text('Valor mensal estimado:', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ ${_estimatedPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _isLoading || _selectedFrequency == null || _selectedModality == null
                    ? null
                    : _submitInterest,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : const Text('Enviar Interesse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}