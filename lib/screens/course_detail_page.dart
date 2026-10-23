import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';
import 'course_form_page.dart';

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

    final isFavorite = context.watch<CourseProvider>().isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Course'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(course: course),
                ),
              );
            },
          ),
        ],
      ),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course.title,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite ? Colors.pink : Colors.grey,
                          ),
                          onPressed: () {
                            context
                                .read<CourseProvider>()
                                .toggleFavorite(course.code);
                          },
                        ),
                      ],
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
                onPressed: () {
                  if (!isFavorite) {
                    context
                        .read<CourseProvider>()
                        .toggleFavorite(course.code);
                  }
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.favorite),
                label: Text(isFavorite ? 'Sudah Favorite' : 'Pilih / Favorite'),
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