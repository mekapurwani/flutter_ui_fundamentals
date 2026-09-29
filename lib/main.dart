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
      home: const ProfileFormPage(),
    );
  }
}

class ProfileFormPage extends StatelessWidget {
  const ProfileFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrollable Content'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Field 1: Nama
            const Text('Nama Lengkap'),
            const SizedBox(height: 6),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Tulis nama lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Field 2: NIM
            const Text('NIM'),
            const SizedBox(height: 6),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Tulis NIM',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Field 3: Email
            const Text('Email'),
            const SizedBox(height: 6),
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Tulis email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Field 4: No HP
            const Text('No. HP'),
            const SizedBox(height: 6),
            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Tulis no HP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Field 5: Alamat
            const Text('Alamat'),
            const SizedBox(height: 6),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tulis alamat lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Field 6: Komentar
            const Text('Komentar'),
            const SizedBox(height: 6),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tulis komentar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Simpan'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}