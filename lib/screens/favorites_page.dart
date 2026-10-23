import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';
import 'course_form_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  void _konfirmasiHapus(BuildContext context, String title, int id) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Yakin ingin menghapus $title?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi == true && context.mounted) {
      final provider = context.read<CourseProvider>();
      final course = provider.courses.firstWhere((c) => c.id == id);
      final berhasil = await provider.deleteCourse(course);

      if (berhasil && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favoriteCourses = provider.courses
        .where((course) => provider.isFavorite(course.code))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Column(
        children: [
          const IdentityHeader(),
          Expanded(
            child: favoriteCourses.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada course favorite.\nTekan ikon hati di daftar course.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: favoriteCourses.length,
                    itemBuilder: (context, index) {
                      final course = favoriteCourses[index];
                      return CourseCard(
                        course: course,
                        isFavorite: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailPage(course: course),
                            ),
                          );
                        },
                        onFavoriteTap: () {
                          context
                              .read<CourseProvider>()
                              .toggleFavorite(course.code);
                        },
                        onLongPress: () {},
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseFormPage(course: course),
                            ),
                          );
                        },
                        onDelete: () => _konfirmasiHapus(
                          context,
                          course.title,
                          course.id!,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}