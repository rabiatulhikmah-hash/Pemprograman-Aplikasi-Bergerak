# Pemprograman-Aplikasi-Bergerak
# Nama : Rabiatul Hikmah
# Nim : 2409116049
------------------------
# 🎬 CineBook — Aplikasi Booking Tiket Bioskop
## Deskripsi Aplikasi
CineBook adalah aplikasi mobile booking tiket bioskop berbasis Flutter yang memungkinkan pengguna memesan tiket secara digital dengan sistem pilihan yang realistis.

Pengguna cukup memilih film, jadwal tayang, dan kursi yang tersedia. Harga tiket akan otomatis menyesuaikan tipe studio (Reguler, VIP, IMAX). Aplikasi ini juga mendukung pengelolaan booking melalui fitur CRUD lengkap dengan validasi form, notifikasi, dan konfirmasi dialog.


## Fitur Aplikasi
| Fitur  | Deskripsi                           |
| ------ | ----------------------------------- |
| Create | Menambahkan booking tiket baru      |
| Read   | Menampilkan daftar booking aktif    |
| Update | Mengedit data booking               |
| Delete | Menghapus booking dengan konfirmasi |
### Fitur Tambahan
| Fitur                 | Deskripsi                                     |
| --------------------- | --------------------------------------------- |
| Multi-Page Navigation | Navigasi antar 4 halaman                      |
| Pilih Film & Jadwal   | Data dipilih dari sistem (bukan manual input) |
| Pilih Kursi           | Kursi menyesuaikan studio                     |
| Harga Otomatis        | Harga muncul sesuai tipe studio               |
| Form Validation       | Validasi input & format email                 |
| Snackbar              | Notifikasi saat submit gagal                  |
| Alert Dialog          | Konfirmasi sebelum hapus data                 |


## 🧩 Widget yang Digunakan
| Kategori        | Widget                                                                      |
| --------------- | --------------------------------------------------------------------------- |
| Struktur Layout | `Scaffold`, `AppBar`, `Column`, `Row`, `Container`, `SafeArea`              |
| Input & Form    | `Form`, `TextFormField`, `DropdownButtonFormField`, `TextEditingController` |
| List & Navigasi | `ListView.builder`, `Navigator`                                             |
| Interaksi       | `ElevatedButton`, `IconButton`, `GestureDetector`                           |
| Notifikasi      | `SnackBar`, `AlertDialog`                                                   |
| Styling         | `BoxDecoration`, `LinearGradient`, `Icon`                                   |

## 📱 Halaman Aplikasi

| File                     | Fungsi                 |
| ------------------------ | ---------------------- |
| `home_page.dart`         | Halaman utama          |
| `add_booking_page.dart`  | Form tambah booking    |
| `my_booking_page.dart`   | Daftar booking & hapus |
| `edit_booking_page.dart` | Form edit booking      |


## 📂 Struktur Folder

```
lib/
├── main.dart
├── data/
│   └── dummy_data.dart
├── models/
│   └── booking.dart
├── pages/
│   ├── home_page.dart
│   ├── add_booking_page.dart
│   ├── my_booking_page.dart
│   └── edit_booking_page.dart
└── widgets/
    └── booking_card.dart
```

## 📱 Implementasi & Tampilan Aplikasi

1. 
<img width="439" height="974" alt="Screenshot 2026-02-26 065350" src="https://github.com/user-attachments/assets/f30d8939-7261-4d3f-956a-d3e017be9371" />

2. 
<img width="439" height="972" alt="Screenshot 2026-02-26 065428" src="https://github.com/user-attachments/assets/25e1d2c2-ddbb-44d5-b180-c2280e3c0678" />

3. 
<img width="439" height="364" alt="Screenshot 2026-02-26 065608" src="https://github.com/user-attachments/assets/c2fcfaa9-c3a9-4af7-b1ae-73b482cf8120" />

<img width="438" height="222" alt="Screenshot 2026-02-26 065645" src="https://github.com/user-attachments/assets/1c3ae62f-bdd2-4cc8-b71a-0af01d589393" />


<img width="418" height="398" alt="Screenshot 2026-02-26 065833" src="https://github.com/user-attachments/assets/cadec696-7616-4060-a92d-0ea3bbb4d0de" />

<img width="436" height="402" alt="Screenshot 2026-02-26 065928" src="https://github.com/user-attachments/assets/1049fe7f-7ad4-4fd2-8772-1c3fe5d57d58" />

<img width="402" height="402" alt="image" src="https://github.com/user-attachments/assets/8b02004f-cc72-463c-bfb9-7521a4320499" />

<img width="436" height="500" alt="image" src="https://github.com/user-attachments/assets/119ac05e-1f8c-4452-93fb-293cc4f13d06" />
