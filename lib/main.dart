import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'models/course.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/home_tab.dart';
import 'screens/courses_tab.dart';
import 'screens/favorites_page.dart';
import 'screens/profile_tab.dart';

const String studentName = 'Ni Luh Meka Purwani';
const String studentId = '2415051089';

const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

Future<List<Course>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body) as List;
    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  throw Exception('HTTP ${response.statusCode}');
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(
        CourseRepository(CourseService()),
      )..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _testFetchCourses();
  }

  Future<void> _testFetchCourses() async {
    try {
      final courses = await fetchCourses();
      debugPrint('BERHASIL: Mendapatkan ${courses.length} course dari API');
      for (var i = 0; i < 3; i++) {
        debugPrint('Course ${i + 1}: ${courses[i].code} - ${courses[i].title} - ${courses[i].status}');
      }
    } catch (e) {
      debugPrint('GAGAL: $e');
    }
  }

  final List<Widget> _pages = const [
    HomeTab(),
    CoursesTab(),
    FavoritesPage(),
    ProfileTab(),
  ];

  Widget _buildNavigationBar() {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        setState(() => currentIndex = index);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
        NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        setState(() => currentIndex = index);
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
        NavigationRailDestination(
            icon: Icon(Icons.school), label: Text('Courses')),
        NavigationRailDestination(
            icon: Icon(Icons.favorite), label: Text('Favorites')),
        NavigationRailDestination(
            icon: Icon(Icons.person), label: Text('Profile')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return Scaffold(
            body: _pages[currentIndex],
            bottomNavigationBar: _buildNavigationBar(),
          );
        }
        return Scaffold(
          body: Row(
            children: [
              _buildNavigationRail(),
              const VerticalDivider(width: 1),
              Expanded(child: _pages[currentIndex]),
            ],
          ),
        );
      },
    );
  }
}