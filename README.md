# Course Data Manager

Aplikasi Flutter untuk memenuhi tugas Pertemuan 7 - RESTful API, Backend Services & Database Integration.

**Nama:** Ni Luh Meka Purwani  
**NIM:** 2415051089

## Deskripsi Aplikasi
Aplikasi ini merupakan pengembangan dari Course Explorer v2 yang kini terintegrasi langsung dengan database PostgreSQL melalui Supabase. Aplikasi mendukung operasi CRUD (Create, Read, Update, Delete) data course secara real-time.

## Arsitektur Singkat
Aplikasi ini menggunakan arsitektur berlapis (layered architecture):
- **UI (Screens/Widgets):** Menangani tampilan dan interaksi pengguna.
- **State (Provider):** Mengelola state (loading, error, data) dan menghubungkan UI dengan Repository.
- **Repository:** Abstraksi yang menyembunyikan detail sumber data dari Provider.
- **Service/Data Source:** Berkomunikasi langsung dengan backend (Supabase / REST API).

Alur data: `UI -> Provider -> Repository -> CourseSupabaseService -> Supabase (PostgreSQL)`

## Backend yang Digunakan
- **Database & API:** Supabase (PostgreSQL).
- **Tabel:** `courses` (id, code, title, credits, status, created_at).

## Cara Menjalankan
1. Pastikan Flutter SDK sudah terinstal.
2. Jalankan `flutter pub get` untuk mengunduh dependency.
3. Hubungkan ke emulator atau perangkat fisik Android.
4. Jalankan `flutter run`.