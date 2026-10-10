import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/identity_header.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final status = course.status;
    Color statusColor;
    String statusLabel;

    if (status == 'done') {
      statusColor = Colors.green;
      statusLabel = 'Selesai';
    } else if (status == 'active') {
      statusColor = Colors.orange;
      statusLabel = 'Berjalan';
    } else {
      statusColor = Colors.grey;
      statusLabel = 'Belum';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IdentityHeader(),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text('Kode: ${course.code}'),
                    const SizedBox(height: 6),
                    Text('SKS: ${course.credits}'),
                    const SizedBox(height: 6),
                    Text(
                      'Status: $statusLabel',
                      style: TextStyle(
                          color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.favorite),
                label: const Text('Pilih / Favorite'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade100,
                  foregroundColor: Colors.pink.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}