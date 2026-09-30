import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Ni Luh Meka Purwani';
const String studentId = '2415051089';

void main() {
  runApp(const MyApp());
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

// ===== Halaman Utama dengan Adaptive Navigation =====
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

// ===== Tab Home =====
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 80, color: Colors.blue),
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

// ===== Tab Courses =====
class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  late Future<Map<String, dynamic>> studentFuture;
  final Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  void _toggleFavorite(String code) {
    setState(() {
      if (favorites.contains(code)) {
        favorites.remove(code);
      } else {
        favorites.add(code);
      }
    });
  }

  void _showLongPressInfo(Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(course['title'] as String),
        content: Text(
          'Kode: ${course['code']}\nSKS: ${course['credits']}\nStatus: ${course['status']}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Course')),
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
          final courses = data['courses'] as List<dynamic>;

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.blue.shade50,
                child: Text(
                  '$studentId - $studentName',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    final String code = course['code'] as String;
                    final bool isFavorite = favorites.contains(code);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Kamu memilih: ${course['title']}',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onLongPress: () => _showLongPressInfo(course),
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          leading: const Icon(Icons.book, color: Colors.blue),
                          title: Text(course['title'] as String),
                          subtitle: Text(code),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.pink : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(code),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.pink.shade50,
                child: Text(
                  '${favorites.length} course di-favorite',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ===== Tab Profile + Form Feedback =====
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

  // STEP 1: Validasi → Unfocus keyboard → Dialog konfirmasi
  Future<void> _konfirmasiSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Sembunyikan keyboard supaya tidak menutupi dialog
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

    if (konfirmasi == true) {
      _submitForm();
    }
  }

  // STEP 2: Loading + SnackBar
  Future<void> _submitForm() async {
    setState(() => _isLoading = true);

    // Simulasi loading 2 detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _hasil = 'Terima kasih ${_namaCtrl.text} (${_nimCtrl.text})!\n'
          'Komentar: ${_komentarCtrl.text}';
    });

    // STEP 3: SnackBar hijau
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil disimpan'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Feedback')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
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

            // Form Feedback
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

                  // Tombol dengan Loading state
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

            // Hasil feedback
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