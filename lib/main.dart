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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$studentId - $studentName',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final data = await loadStudentData();
                  debugPrint('=== Data dari JSON ===');
                  debugPrint('Student: ${data['student']}');
                  debugPrint('Jumlah courses: ${(data['courses'] as List).length}');
                  debugPrint('Course pertama: ${data['courses'][0]}');
                },
                child: const Text('Test Baca JSON'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}