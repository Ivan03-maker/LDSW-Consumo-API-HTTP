import 'package:flutter/material.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos Stack para superponer elementos (Imagen de fondo + Contenido)
      body: Stack(
        children: [
          // 1. Imagen de fondo que ocupa toda la pantalla
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1518770660439-4636190af475', // Puedes cambiar esta URL por una imagen local o asset
              fit: BoxFit.cover,
            ),
          ),

          // 2. Capa oscura semitransparente para mejorar la lectura del texto
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          // 3. Contenido principal centrado (Texto, Nombre de la App e Icono)
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icono decorativo de la app
                  const Icon(
                    Icons.devices_outlined,
                    size: 64.0,
                    color: Color(0xFF0076A3),
                  ),
                  const SizedBox(height: 16.0),

                  // Nombre de la aplicación
                  const Text(
                    'LDSW',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF022933),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Mensaje de bienvenida
                  const Text(
                    'Hello World! Bienvenido a LDSW',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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