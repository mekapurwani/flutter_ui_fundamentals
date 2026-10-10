import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

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
                              builder: (_) =>
                                  CourseDetailPage(course: course),
                            ),
                          );
                        },
                        onFavoriteTap: () {
                          context
                              .read<CourseProvider>()
                              .toggleFavorite(course.code);
                        },
                        onLongPress: () {},
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}