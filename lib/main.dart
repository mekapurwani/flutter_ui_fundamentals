import 'package:flutter/material.dart';

const String studentName = 'Ni Luh Meka Purwani';
const String studentId = '2415051089';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Expanded, Flexible, Wrap'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Identitas
              Text(
                '$studentId - $studentName',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // ===== Panel 2:1 dengan Expanded flex =====
              const Text('Panel 2:1 (Expanded flex)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 80,
                      color: Colors.blue.shade200,
                      alignment: Alignment.center,
                      child: const Text('A (flex 2)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 80,
                      color: Colors.green.shade200,
                      alignment: Alignment.center,
                      child: const Text('B (flex 1)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ===== Wrap: 6 Chip Skill =====
              const Text('Skill (Wrap)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text('Flutter')),
                  Chip(label: Text('Dart')),
                  Chip(label: Text('UI/UX')),
                  Chip(label: Text('Android')),
                  Chip(label: Text('Git')),
                  Chip(label: Text('Firebase')),
                ],
              ),
              const SizedBox(height: 24),

              // ===== Perbandingan: Row biasa (bisa overflow) =====
              const Text('Perbandingan: Row biasa (overflow)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    Chip(label: Text('Flutter')),
                    SizedBox(width: 8),
                    Chip(label: Text('Dart')),
                    SizedBox(width: 8),
                    Chip(label: Text('UI/UX')),
                    SizedBox(width: 8),
                    Chip(label: Text('Android')),
                    SizedBox(width: 8),
                    Chip(label: Text('Git')),
                    SizedBox(width: 8),
                    Chip(label: Text('Firebase')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}