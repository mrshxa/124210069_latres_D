# app_latresp

A new Flutter project.

## Getting Started

Aplikasi Flutter toko online. Data produk dari API eksternal <https://dummyjson.com/products>.

## Cara menjalankan

1. Buka `lib/config.dart`, ganti `kNim` dengan *NIM 124210069* (password login = NIM).

## Fitur

| Fitur | Implementasiny |
|---|---|
| Login (username bebas, password = NIM) | `pages/login_page.dart` |
| Session tersimpan (tidak login ulang) | `services/session_service.dart` (Shared Preferences) |
| Bottom navigation (Home, Profile) | `pages/main_page.dart` |
| Home: info username, tombol cart, list produk dari API | `pages/home_page.dart` |
| Detail produk + qty (0 < qty <= stok) + Add to Cart | `pages/detail_page.dart` |
| Cart per user + hapus item | `pages/cart_page.dart` (Hive) |
| Profile: username, deskripsi, logout | `pages/profile_page.dart` |

## Struktur folder

```
app_latresp/
├── pubspec.yaml            # dependency: http, hive, hive_flutter, shared_preferences
├── README.md               # penjelasan ini
└── lib/
    ├── main.dart           # entry point: init Hive, cek session, tentukan halaman awal
    ├── config.dart         # konstanta: NIM (password) & URL API
    ├── models/
    │   └── product.dart    # model Product (dari API) & CartItem (disimpan di Hive)
    ├── services/
    │   ├── api_service.dart      # HTTP request ke dummyjson.com
    │   ├── session_service.dart  # simpan/baca/hapus username (Shared Preferences)
    │   └── cart_service.dart     # CRUD cart di Hive, key "<username>_<productId>"
    └── pages/
        ├── login_page.dart
        ├── main_page.dart        # Scaffold + bottom navigation
        ├── home_page.dart
        ├── detail_page.dart
        ├── cart_page.dart
        └── profile_page.dart
```

## Catatan 

- *Cart per user*: setiap item di Hive memakai key `username_productId`, jadi saat ganti
  akun (logout lalu login username lain) cart yang tampil berbeda.
- *Session*: saat app dibuka, `main.dart` membaca username dari Shared Preferences;
  jika ada langsung ke `MainPage`, jika tidak ke `LoginPage`. Logout menghapus session.
- Cart page memakai `ValueListenableBuilder` pada box Hive sehingga otomatis refresh saat item dihapus.
