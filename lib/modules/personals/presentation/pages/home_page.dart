import 'package:flutter/material.dart';
import 'dart:async'; 

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

  final _searchController = TextEditingController();
  
  List<PersonalEntity> _allPersonals = []; 
  List<PersonalEntity> _filteredPersonals = []; 
  
  final Set<String> _allSpecialties = {};
  final Set<String> _selectedSpecialties = {};

  Future<void>? _loadPersonalsFuture;
  
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    repository = PersonalRepositoryImpl(datasource: PersonalRemoteDatasource());
    
    _loadPersonalsFuture = _fetchAndPrepareData();

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _applyFilters();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchAndPrepareData() async {
    final personals = await repository.getPersonals();
    
    final specialties = personals.expand((p) => p.specialties).toSet();
    
    setState(() {
      _allPersonals = personals;
      _filteredPersonals = personals;
      _allSpecialties.addAll(specialties);
    });
  }

  void _applyFilters() {
    List<PersonalEntity> temp_list = List.from(_allPersonals);
    final searchQuery = _searchController.text.toLowerCase();

    if (searchQuery.isNotEmpty) {
      temp_list = temp_list.where((personal) {
        return personal.name.toLowerCase().contains(searchQuery);
      }).toList();
    }

    if (_selectedSpecialties.isNotEmpty) {
      temp_list = temp_list.where((personal) {
        return _selectedSpecialties.every((specialty) => personal.specialties.contains(specialty));
      }).toList();
    }

    setState(() {
      _filteredPersonals = temp_list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubra Personais'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchAndFilterUI(),

          Expanded(
            child: FutureBuilder(
              future: _loadPersonalsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
                }
                if (_filteredPersonals.isEmpty) {
                  return const Center(child: Text('Nenhum personal encontrado com esses critérios.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _filteredPersonals.length,
                  itemBuilder: (context, index) {
                    final personal = _filteredPersonals[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
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
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterUI() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campo de Busca
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por nome...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          if (_allSpecialties.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _allSpecialties.map((specialty) {
                  final isSelected = _selectedSpecialties.contains(specialty);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(specialty),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSpecialties.add(specialty);
                          } else {
                            _selectedSpecialties.remove(specialty);
                          }
                          _applyFilters();
                        });
                      },
                      selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                      checkmarkColor: Theme.of(context).primaryColor,
                    ),
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}