# Course Explorer v2

 State Management & Mobile Application Architecture.

**Nama:** Ni Luh Meka Purwani  
**NIM:** 2415051089

## Struktur Folder

| Folder | Tanggung Jawab |
|--------|----------------|
| `models/` | Representasi data (`Course`) dan parsing JSON (`Course.fromJson`) |
| `services/` | Detail teknis akses data mentah (baca JSON, decode). Tidak mengandung UI. |
| `repositories/` | Abstraksi sumber data. Menyembunyikan detail Service dari Provider. |
| `providers/` | State + action (`CourseProvider`). Mengelola loading/error/data. Tidak menyimpan BuildContext. |
| `screens/` | Halaman UI (Home, Courses, Favorites, Profile, Detail). Murni presentasi, akses data lewat Provider. |
| `widgets/` | Komponen UI yang reusable (`IdentityHeader`, `CourseCard`). |

## Alur Dependency

```
Screen/Widget → Provider → Repository → Service/Data Source
```

UI tidak memanggil `rootBundle` atau `jsonDecode` secara langsung — semua akses data lewat Provider.

## Cara Menjalankan

```bash
flutter pub get
flutter run
```