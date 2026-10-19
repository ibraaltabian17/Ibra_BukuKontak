# LEMBAR KERJA MURID (LKM)
## Deployment Aplikasi Flutter ke Android

- **Mata Pelajaran:** Pemrograman Perangkat Bergerak
- **Nama:** Ibra Al Tabian
- **Kelas:** XII RPL B
- **Sekolah:** SMK Negeri 5 Surakarta
- **Tanggal:** 19 Oktober 2026

---

## Ringkasan Penyesuaian Sebelum Deployment

1. **Sinkronisasi Fitur Kontak Favorit:**
   - Menambahkan properti `isFavorit` pada model `Kontak` (`lib/main.dart`).
   - Menyimpan status favorit ke Cloud Firestore secara real-time (`isFavorit: true / false`).
   - Mengubah **Tab Favorit** yang sebelumnya bersifat statis (nama teman) menjadi dinamis, menampilkan daftar kontak yang telah ditandai dengan ikon bintang dari daftar kontak.
   - Menyediakan tombol bintang (favorit) langsung pada item daftar kontak untuk memudahkan penambahan/penghapusan kontak favorit.

2. **Perubahan Label Aplikasi:**
   - File: `android/app/src/main/AndroidManifest.xml`
   - Nilai awal: `android:label="material_design"`
   - Diubah menjadi: `android:label="Contact BookApp"`

---

## TUGAS 1: Deployment Aplikasi Buku Kontak ke Android (APK Release)

### 1. Langkah-Langkah Build APK Release
1. Membuka terminal di direktori proyek `BukuKontak`.
2. Menyelaraskan dependensi:
   ```bash
   flutter pub get
   ```
3. Menjalankan proses pembersihan cache build:
   ```bash
   flutter clean
   ```
4. Menjalankan proses kompilasi APK release:
   ```bash
   flutter build apk --release
   ```
5. **Hasil Build:**
   ```text
   ✓ Built build/app/outputs/flutter-apk/app-release.apk (52.9MB)
   ```
   File instalasi APK siap disalin ke perangkat HP Android untuk diinstal dan diuji.

---

### 2. Catatan Kendala & Solusi Konfigurasi Build

| Masalah yang Ditemukan | Penyebab | Solusi yang Diterapkan |
| :--- | :--- | :--- |
| **Minimum SDK Plugin** | Plugin `cloud_firestore` membutuhkan SDK minimum Android lebih tinggi. | Mengubah `minSdk = 23` pada `defaultConfig` di `android/app/build.gradle`. |
| **Java & Kotlin Incompatibility** | Lingkungan Android Studio menggunakan OpenJDK modern (Java 25) sehingga compiler Gradle lama gagal memproses bytecode (`Unsupported class file major version 69`). | Memperbarui Gradle Wrapper di `android/gradle/wrapper/gradle-wrapper.properties` menjadi `gradle-9.1.0-all.zip`. |
| **Incompatible Kotlin Metadata** | Library `firebase-auth` menggunakan metadata Kotlin versi 2.3.0. | Memperbarui plugin `org.jetbrains.kotlin.android` di `android/settings.gradle` menjadi versi `2.3.0`. |
| **Lint Vital Check Failure** | Analisis Lint bawaan Android memeriksa bytecode release dan gagal dengan parser versi Java baru. | Menambahkan konfigurasi `checkReleaseBuilds = false` dan `abortOnError = false` pada blok `lint` di `android/app/build.gradle` serta menonaktifkan task `lintVital` pada `android/build.gradle`. |

---

### 3. Dokumentasi Hasil Pengujian (Panduan Screenshot)

#### **Screenshot 1: Tampilan Ikon Aplikasi & Label**
- **Sisi Kiri (Tampilan Ikon di HP):** Tangkapan layar layar utama HP (home screen / app drawer) yang menampilkan ikon aplikasi dengan nama **Contact BookApp**.
- **Sisi Kanan (Android Label di Kode):** Tangkapan layar file `android/app/src/main/AndroidManifest.xml` pada bagian:
  ```xml
  <application
      android:label="Contact BookApp"
      android:name="${applicationName}"
      android:icon="@mipmap/ic_launcher">
  ```

#### **Screenshot 2: Tampilan Awal Aplikasi di HP**
- Tangkapan layar saat aplikasi Buku Kontak dibuka di HP Android, memperlihatkan `AppBar` bertuliskan **BUKU KONTAK**, Tab Kontak, Tab Favorit, serta `FloatingActionButton` (+).

#### **Screenshot 3: Pengujian Tambah Kontak Baru**
- **Aplikasi di HP:** Mengisi form Tambah Kontak (Nama, Email, Nomor HP, Kategori) lalu menekan tombol Simpan hingga data tampil di daftar kontak.
- **Cloud Firestore:** Membuka konsol Firebase Firestore di browser dan mengambil screenshot dokumen baru yang berhasil tersimpan di koleksi `kontak`.

#### **Screenshot 4: Pengujian Edit Kontak**
- **Aplikasi di HP:** Menekan ikon pensil (edit) pada salah satu kontak, mengubah datanya (misal nomor HP/kategori), lalu menyimpan dan menampilkan hasil pembaruan di aplikasi.
- **Cloud Firestore:** Tangkapan layar konsol Firestore yang menunjukkan perubahan field data yang diperbarui secara langsung.

#### **Screenshot 5: Pengujian Hapus Kontak**
- **Aplikasi di HP:** Menekan tombol hapus (ikon tempat sampah), menyetujui dialog konfirmasi hapus, hingga kontak hilang dari daftar.
- **Cloud Firestore:** Tangkapan layar konsol Firestore yang membuktikan dokumen kontak tersebut telah terhapus dari koleksi `kontak`.

---

### 4. Kesimpulan Akhir Praktikum

> **Kesimpulan:**  
> Praktikum deployment aplikasi Flutter ke Android berhasil dilakukan dengan menghasilkan file instalasi release (`app-release.apk`). Penyesuaian konfigurasi Android seperti `minSdk = 23`, keselarasan versi Kotlin Gradle Plugin, dan Gradle Wrapper terbukti penting agar plugin modern seperti Cloud Firestore dan Firebase Auth dapat dikompilasi tanpa konflik.  
> Setelah file APK diinstal pada HP Android, seluruh fitur utama—meliputi penambahan data kontak, pembaruan (edit) kontak, penghapusan kontak dengan dialog konfirmasi, serta pengelolaan kontak favorit—berfungsi dengan baik dan tersinkronisasi secara real-time dua arah dengan database Cloud Firestore.

---

## TUGAS 2: Mengganti Launcher Icon Aplikasi

### 1. Kegiatan 1: Pengamatan Ikon Bawaan Flutter
- **Hasil Pengamatan:** Pada instalasi awal (Tugas 1), aplikasi masih menggunakan ikon bawaan Flutter (logo burung Flutter biru-putih). Hal ini terjadi karena folder `res/mipmap-*` masih memuat file default `ic_launcher.png`.

---

### 2. Kegiatan 2: Pembuatan Desain Ikon Aplikasi
- **Konsep Desain:** Ikon buku kontak modern bertema *Material Blue* berbentuk binder agenda catatan dengan aksen penanda pita (bookmark ribbon) merah dan siluet profil kontak di bagian tengah, dilengkapi efek squircle elegan.
- **Format & Ukuran Master:** PNG transparan resolusi tinggi (512x512 piksel).
- **Lokasi File Desain:** `assets/icon/app_icon.png` (sudah didaftarkan ke `pubspec.yaml`).

---

### 3. Kegiatan 3: Langkah-Langkah Mengganti Ikon Aplikasi

#### A. Sumber Referensi
1. **Judul Dokumentasi:** *Flutter Official Documentation - Deploying to Android (Customize the app's launcher icon)*
2. **Tautan Sumber:** [https://docs.flutter.dev/deployment/android](https://docs.flutter.dev/deployment/android) / package [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

#### B. Langkah-Langkah Pelaksanaan (Secara Berurutan):
1. **Mempersiapkan File Ikon:**
   Membuat aset gambar ikon baru bertema Buku Kontak dengan format PNG dan menyimpannya di folder `assets/icon/app_icon.png`.
2. **Mendaftarkan Aset ke `pubspec.yaml`:**
   Menambahkan path aset ikon pada konfigurasi `assets` di file `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/images/profile.png
       - assets/icon/app_icon.png
   ```
3. **Mengonversi dan Menempatkan Ikon pada Android Resource (`res`):**
   Membuat file ikon `ic_launcher.png` dengan resolusi yang sesuai untuk masing-masing densitas layar Android di dalam direktori `android/app/src/main/res/`:
   - `mipmap-mdpi`: 48 × 48 px
   - `mipmap-hdpi`: 72 × 72 px
   - `mipmap-xhdpi`: 96 × 96 px
   - `mipmap-xxhdpi`: 144 × 144 px
   - `mipmap-xxxhdpi`: 192 × 192 px
4. **Memastikan Referensi di `AndroidManifest.xml`:**
   Memastikan atribut `android:icon` pada tag `<application>` mengarah ke resource launcher icon:
   ```xml
   android:icon="@mipmap/ic_launcher"
   ```
5. **Melakukan Build Ulang APK Release:**
   Menjalankan perintah build ulang:
   ```bash
   flutter build apk --release
   ```
6. **Instalasi dan Verifikasi:**
   Memasang file `app-release.apk` hasil build baru ke HP Android dan memverifikasi bahwa ikon aplikasi di layar HP telah berubah dari ikon default Flutter menjadi ikon kustom Buku Kontak.
