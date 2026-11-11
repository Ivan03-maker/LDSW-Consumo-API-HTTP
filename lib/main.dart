import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const LDSWApp());
}

class LDSWApp extends StatelessWidget {
  const LDSWApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LDSW App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

// 1. Convertimos a StatefulWidget para gestionar estados de carga y datos de red
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? pokemonData;
  bool isLoading = true;
  String errorMessage = '';

  // Función para consumir la PokéAPI
  Future<void> fetchPokemon() async {
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
          errorMessage = 'Error del servidor: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error de red: Verifique su conexión a internet.';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPokemon(); // Dispara la petición al iniciar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Imagen de fondo que ocupa toda la pantalla
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1518770660439-4636190af475',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Capa oscura semitransparente para mejorar la lectura
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // 3. Contenido principal centrado con los datos de la API
          Center(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: isLoading
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando datos de la API...'),
                      ],
                    )
                  : errorMessage.isNotEmpty
                      ? Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icono o Imagen del Pokémon obtenida por red
                            if (pokemonData != null &&
                                pokemonData!['sprites'] != null)
                              Image.network(
                                pokemonData!['sprites']['front_default'],
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            const SizedBox(height: 8.0),

                            // Nombre del Pokémon obtenido de la API
                            Text(
                              pokemonData!['name'].toString().toUpperCase(),
                              style: const TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF022933),
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8.0),

                            // Datos detallados obtenidos vía HTTP
                            Text(
                              'Peso: ${pokemonData!['weight']} | Altura: ${pokemonData!['height']}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12.0),

                            const Text(
                              '¡Petición HTTP realizada con éxito!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}