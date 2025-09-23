# Myop-Myup Dessert - Aplikasi Kasir Flutter

Aplikasi kasir Point-of-Sale (POS) sederhana yang dibangun menggunakan Flutter untuk platform web. Aplikasi ini dirancang sebagai Final Project untuk memenuhi tugas mata pelajaran Mobile Development di SMK IT Assyifa.

## Fitur Utama

* **Autentikasi Pengguna**: Sistem login dan registrasi yang aman menggunakan Firebase Authentication.
* **Katalog Produk Dinamis**: Menampilkan daftar produk dessert yang diambil langsung dari TheMealDB API.
* **Pencarian & Paginasi**: Memudahkan pencarian produk dengan filter *real-time* dan *infinite scrolling* untuk performa yang cepat.
* **Manajemen Keranjang**: Menambah, mengurangi, dan menghapus produk dari keranjang belanja. Keranjang tersimpan di perangkat (persisten) bahkan setelah *refresh*.
* **Sistem Routing**: Navigasi antar halaman yang andal menggunakan GoRouter, mempertahankan posisi halaman saat di-*refresh*.
* **Riwayat Transaksi**: Menyimpan semua transaksi yang berhasil ke Cloud Firestore.
* **Cetak & Ekspor Struk**: Setiap riwayat transaksi dapat dilihat dalam format struk dan dapat dicetak langsung atau diekspor sebagai PDF.

## Teknologi yang Digunakan

* **Framework**: Flutter 3.x
* **Bahasa**: Dart
* **Backend & Database**: Firebase (Authentication & Cloud Firestore)
* **Manajemen State**: Provider
* **Routing**: GoRouter
* **Penyimpanan Lokal**: SharedPreferences
* **API**: [TheMealDB API](https://www.themealdb.com/api.php)
* **Cetak/PDF**: Printing & PDF packages

## Cara Menjalankan Proyek

1.  **Prasyarat**:
    * Pastikan Flutter SDK sudah terinstal di komputer Anda.
    * Pastikan Anda sudah memiliki proyek Firebase dan file `firebase_options.dart` sudah dikonfigurasi.

2.  **Clone Repositori**:
    ```bash
    git clone https://github.com/clownface471/final-project-flutter
    cd nama-folder-proyek
    ```

3.  **Install Dependensi**:
    ```bash
    flutter pub get
    ```

4.  **Jalankan Aplikasi (Mode Rilis)**:
    Untuk performa terbaik, jalankan aplikasi web dalam mode rilis L.
    ```bash
    flutter run -d chrome --release 
    ```

## Demo Aplikasi

https://youtube.com/shorts/_dAd6rpa1_E?feature=share

---
*Dibuat untuk Final Project Flutter - Fata Adzaky Muhammad*