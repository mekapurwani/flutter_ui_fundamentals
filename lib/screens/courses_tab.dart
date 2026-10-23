import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_detail_page.dart';
import 'course_form_page.dart';

class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  void _showLongPressInfo(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(course.title),
        content: Text(
          'Kode: ${course.code}\nSKS: ${course.credits}\nStatus: ${course.status}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Course course) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(course: course),
      ),
    );

    if (result == true && context.mounted) {
      context.read<CourseProvider>().toggleFavorite(course.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${course.title}" ditambahkan ke favorite'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _konfirmasiHapus(BuildContext context, Course course) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Yakin ingin menghapus ${course.title}?'),
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
      final berhasil = await context.read<CourseProvider>().deleteCourse(course);
      
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
    return Scaffold(
      appBar: AppBar(title: const Text('Course Data Manager')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final courseProvider = context.watch<CourseProvider>();
          final bool isCompact = constraints.maxWidth < 600;
          final bool isExpanded = constraints.maxWidth >= 840;
          final int columns = isCompact ? 1 : (isExpanded ? 3 : 2);

          return Column(
            children: [
              const IdentityHeader(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CourseFormPage()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Course'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade100,
                      foregroundColor: Colors.green.shade800,
                    ),
                  ),
                ),
              ),
              
              if (courseProvider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (courseProvider.error != null)
                Expanded(
                  child: ErrorView(
                    message: 'Gagal memuat data: ${courseProvider.error}',
                    onRetry: () => courseProvider.loadCourses(),
                  ),
                )
              else if (courseProvider.courses.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('Data course belum tersedia'),
                  ),
                )
              else ...[
                Expanded(
                  child: isCompact
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: courseProvider.courses.length,
                          itemBuilder: (context, index) {
                            final course = courseProvider.courses[index];
                            return CourseCard(
                              course: course,
                              isFavorite: courseProvider.isFavorite(course.code),
                              onTap: () => _openDetail(context, course),
                              onFavoriteTap: () => context
                                  .read<CourseProvider>()
                                  .toggleFavorite(course.code),
                              onLongPress: () => _showLongPressInfo(context, course),
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseFormPage(course: course),
                                  ),
                                );
                              },
                              onDelete: () => _konfirmasiHapus(context, course),
                            );
                          },
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: courseProvider.courses.length,
                          itemBuilder: (context, index) {
                            final course = courseProvider.courses[index];
                            return CourseCard(
                              course: course,
                              isFavorite: courseProvider.isFavorite(course.code),
                              onTap: () => _openDetail(context, course),
                              onFavoriteTap: () => context
                                  .read<CourseProvider>()
                                  .toggleFavorite(course.code),
                              onLongPress: () => _showLongPressInfo(context, course),
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CourseFormPage(course: course),
                                  ),
                                );
                              },
                              onDelete: () => _konfirmasiHapus(context, course),
                            );
                          },
                        ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.pink.shade50,
                  child: Consumer<CourseProvider>(
                    builder: (context, provider, child) {
                      return Text(
                        '${provider.favorites.length} course di-favorite',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}