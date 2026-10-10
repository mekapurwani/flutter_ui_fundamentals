import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'models/course.dart';
import 'course_state.dart';

const String studentName = 'Ni Luh Meka Purwani';
const String studentId = '2415051089';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const MyApp(),
    ),
  );
}

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

  final List<Widget> _pages = const [
    HomeTab(),
    CoursesTab(),
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

class IdentityHeader extends StatelessWidget {
  const IdentityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.blue.shade50,
      child: Text(
        '$studentId - $studentName',
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CourseCard extends StatefulWidget {
  final Course course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onLongPress;

  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onLongPress,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _showDetail = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.course.status;
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.book, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.course.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.isFavorite ? Colors.pink : Colors.grey,
                    ),
                    onPressed: widget.onFavoriteTap,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.course.code} • ${widget.course.credits} SKS',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showDetail = !_showDetail;
                      });
                    },
                    child: Text(_showDetail ? 'Hide' : 'Show'),
                  ),
                ],
              ),
              if (_showDetail) ...[
                const Divider(),
                Text(
                  'Detail: Course ini membahas ${widget.course.title}.',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Selamat datang di Course Explorer',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                '$studentId - $studentName',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  void _showLongPressInfo(Course course) {
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

  void _openDetail(Course course) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(course: course),
      ),
    );

    if (result == true) {
      if (!mounted) return;
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final coursesData = data['courses'] as List<dynamic>;
          final courses = coursesData
              .map((e) => Course.fromJson(e as Map<String, dynamic>))
              .toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isCompact = constraints.maxWidth < 600;
              final bool isExpanded = constraints.maxWidth >= 840;
              final int columns = isCompact ? 1 : (isExpanded ? 3 : 2);

              final courseProvider = context.watch<CourseProvider>();

              return Column(
                children: [
                  const IdentityHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          'Total: ${courses.length} course',
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
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              final course = courses[index];
                              return CourseCard(
                                course: course,
                                isFavorite:
                                    courseProvider.isFavorite(course.code),
                                onTap: () => _openDetail(course),
                                onFavoriteTap: () => context
                                    .read<CourseProvider>()
                                    .toggleFavorite(course.code),
                                onLongPress: () =>
                                    _showLongPressInfo(course),
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
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              final course = courses[index];
                              return CourseCard(
                                course: course,
                                isFavorite:
                                    courseProvider.isFavorite(course.code),
                                onTap: () => _openDetail(course),
                                onFavoriteTap: () => context
                                    .read<CourseProvider>()
                                    .toggleFavorite(course.code),
                                onLongPress: () =>
                                    _showLongPressInfo(course),
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
              );
            },
          );
        },
      ),
    );
  }
}

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

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController(text: studentName);
  final _nimCtrl = TextEditingController(text: studentId);
  final _komentarCtrl = TextEditingController();

  String? _hasil;
  bool _isLoading = false;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _nimCtrl.dispose();
    _komentarCtrl.dispose();
    super.dispose();
  }

  Future<void> _konfirmasiSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah data sudah benar dan ingin dikirim?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );

    if (konfirmasi == true) _submitForm();
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _hasil = 'Terima kasih ${_namaCtrl.text} (${_nimCtrl.text})!\n'
          'Komentar: ${_komentarCtrl.text}';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil disimpan'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    studentName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    studentId,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Form Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nimCtrl,
                    decoration: const InputDecoration(
                      labelText: 'NIM',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'NIM wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _komentarCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Komentar',
                      hintText: 'Minimal 5 karakter',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Komentar wajib diisi';
                      }
                      if (value.trim().length < 5) {
                        return 'Komentar minimal 5 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _konfirmasiSubmit,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(_isLoading ? 'Mengirim...' : 'Kirim Feedback'),
                    ),
                  ),
                ],
              ),
            ),
            if (_hasil != null) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  _hasil!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}