import 'package:flutter/material.dart';

const String studentName = 'Ni Luh Meka Purwani';
const String studentId = '2415051089';

void main() {
  runApp(const MyApp());
}

// ===== Data Collection =====
final List<Map<String, dynamic>> topics = [
  {'title': 'Git & GitHub', 'subtitle': 'Version control', 'done': true},
  {'title': 'Dart Fundamentals', 'subtitle': 'Language basics', 'done': true},
  {'title': 'Flutter UI Fundamentals', 'subtitle': 'Widgets & layout', 'done': false},
  {'title': '$studentId - $studentName', 'subtitle': 'Pemilik aplikasi', 'done': false},
];

// ===== Halaman List Topics =====
class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hitung jumlah topik yang selesai
    final int completed = topics.where((item) => item['done'] == true).length;

    return Column(
      children: [
        // Identitas Mahasiswa
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '$studentId - $studentName',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // Ringkasan
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$completed dari ${topics.length} topik selesai',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        // List dengan Card
        Expanded(
          child: ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final item = topics[index];
              final bool isDone = item['done'] == true;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    isDone ? Icons.check_circle : Icons.schedule,
                    color: isDone ? Colors.green : Colors.orange,
                  ),
                  title: Text(item['title'] as String),
                  subtitle: Text(item['subtitle'] as String),
                  trailing: Text(
                    isDone ? 'Selesai' : 'Belum',
                    style: TextStyle(
                      color: isDone ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter UI Fundamentals'),
        ),
        body: const TopicsPage(),
      ),
    );
  }
}