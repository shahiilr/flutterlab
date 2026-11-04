

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student App',
      debugShowCheckedModeBanner: true,
      home: const StudentApp(),
    );
  }
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Application',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ), // AppBar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Welcome User!!',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              const Icon(Icons.call, size: 32),
              const SizedBox(height: 16),
              const Icon(Icons.person, size: 32),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Submit'),
              ), // ElevatedButton
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ), // TextField
              const SizedBox(height: 24),
              Image.network(
                'https://static.vecteezy.com/system/resources/previews/033/692/783/non_2x/motorcycle-rider-rides-on-a-race-track-at-sunset-motion-blur-motorcycle-rider-on-sport-bike-rides-fast-on-race-track-at-sunset-extreme-athlete-sport-motorcycles-racing-ai-generated-free-photo.jpg',
                height: 220,
                fit: BoxFit.contain,
              ), // Image
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
