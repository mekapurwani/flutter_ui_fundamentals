import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Ni Luh Meka Purwani';
const String studentId = '2415051089';

void main() {
  runApp(const MyApp());
}

// ===== Function pembaca JSON =====
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

// ===== Reusable Widget: Summary Card (dengan icon & warna) =====
Widget buildSummaryCard(
    String value, String label, IconData icon, Color color) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}

// ===== Reusable Widget: Course Item =====
Widget buildCourseItem(Map<String, dynamic> course) {
  final String status = course['status'] as String;

  IconData icon;
  Color color;
  String label;

  if (status == 'done') {
    icon = Icons.check_circle;
    color = Colors.green;
    label = 'Selesai';
  } else if (status == 'active') {
    icon = Icons.play_circle;
    color = Colors.orange;
    label = 'Berjalan';
  } else {
    icon = Icons.schedule;
    color = Colors.grey;
    label = 'Belum';
  }

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      leading: Icon(icon, color: color),
      title: Text(course['title'] as String),
      subtitle: Text(
        '${course['code']} • ${course['credits']} SKS',
      ),
      trailing: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ),
  );
}

// ===== Dashboard Page =====
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Learning Dashboard'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat data: ${snapshot.error}'),
            );
          }

          // Data
          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          // Hitung total SKS
          final int totalCredits = courses.fold<int>(
            0,
            (sum, item) => sum + (item['credits'] as int),
          );
          // Hitung jumlah topik selesai
          final int completed =
              courses.where((c) => c['status'] == 'done').length;

          return SafeArea(
            child: Column(
              children: [
                // ===== Profile Card =====
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/profile.jpg'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NIM: ${student['nim']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Nama: ${student['name']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ===== Summary Row (dengan icon & warna) =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      buildSummaryCard(
                          '${courses.length}', 'Topik', Icons.book, Colors.blue),
                      const SizedBox(width: 8),
                      buildSummaryCard('$totalCredits', 'SKS', Icons.school,
                          Colors.purple),
                      const SizedBox(width: 8),
                      buildSummaryCard('$completed', 'Selesai',
                          Icons.check_circle, Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ===== Judul List =====
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Daftar Materi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ===== List Courses =====
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index] as Map<String, dynamic>;
                      return buildCourseItem(course);
                    },
                  ),
                ),

                // ===== Footer =====
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Data list dimuat dari JSON statik',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),
    );
  }
}