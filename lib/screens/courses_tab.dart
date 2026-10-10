import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final courseProvider = context.watch<CourseProvider>();
          final bool isCompact = constraints.maxWidth < 600;
          final bool isExpanded = constraints.maxWidth >= 840;
          final int columns = isCompact ? 1 : (isExpanded ? 3 : 2);

          return Column(
            children: [
              const IdentityHeader(),
              if (courseProvider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (courseProvider.error != null)
                Expanded(
                  child: Center(
                    child: Text(
                      'Gagal memuat data: ${courseProvider.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Total: ${courseProvider.courses.length} course',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        'Favorite: ${courseProvider.favorites.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isCompact
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: courseProvider.courses.length,
                          itemBuilder: (context, index) {
                            final course = courseProvider.courses[index];
                            return CourseCard(
                              course: course,
                              isFavorite:
                                  courseProvider.isFavorite(course.code),
                              onTap: () => _openDetail(context, course),
                              onFavoriteTap: () => context
                                  .read<CourseProvider>()
                                  .toggleFavorite(course.code),
                              onLongPress: () =>
                                  _showLongPressInfo(context, course),
                            );
                          },
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                              isFavorite:
                                  courseProvider.isFavorite(course.code),
                              onTap: () => _openDetail(context, course),
                              onFavoriteTap: () => context
                                  .read<CourseProvider>()
                                  .toggleFavorite(course.code),
                              onLongPress: () =>
                                  _showLongPressInfo(context, course),
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