import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  Map<String, dynamic>? pokemonData;
  bool isLoading = false;
  String errorMessage = '';

  // Función para realizar la petición HTTP GET a la PokéAPI
  Future<void> fetchPokemon() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/pikachu'),
      );

      if (response.statusCode == 200) {
        setState(() {
          pokemonData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error en el servidor: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error de conexión: Verifica tu acceso a internet.';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPokemon(); // Realiza la petición al cargar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumo de PokéAPI - LDSW'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : errorMessage.isNotEmpty
                  ? Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    )
                  : pokemonData == null
                      ? const Text('Sin datos disponibles', style: TextStyle(color: Colors.white))
                      : Card(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  pokemonData!['name'].toString().toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Image.network(
                                  pokemonData!['sprites']['front_default'],
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Peso: ${pokemonData!['weight']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  'Altura: ${pokemonData!['height']}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
        ),
      ),
    );
  }
}