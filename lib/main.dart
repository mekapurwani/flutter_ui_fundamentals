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
          title: const Text('Flutter UI Fundamentals'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Step 3: Foto profil
              CircleAvatar(
                radius: 46,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(height: 12),
              // Step 1: Nama (tebal)
              Text(
                studentName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              // Step 1: NIM
              Text(studentId),
              const SizedBox(height: 8),
              // Step 2: Icon + deskripsi
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 8),
                  Text('Mobile Programming Student'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}