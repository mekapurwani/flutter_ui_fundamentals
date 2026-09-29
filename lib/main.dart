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
          title: const Text('MediaQuery Test'),
        ),
        body: const MediaQueryPage(),
      ),
    );
  }
}

class MediaQueryPage extends StatelessWidget {
  const MediaQueryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Baca ukuran & orientasi layar
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    // Breakpoint sederhana: < 600 = Compact, >= 600 = Wide
    final String category = size.width < 600 ? 'Compact' : 'Wide';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text('Width: ${size.width.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 16)),
            Text('Height: ${size.height.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 16)),
            Text('Orientation: $orientation',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              'Kategori: $category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: category == 'Compact' ? Colors.blue : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}