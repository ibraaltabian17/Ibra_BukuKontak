import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design/main.dart';

void main() {
  testWidgets('Model Kontak memiliki properti dan getter inisial yang benar',
      (WidgetTester tester) async {
    final kontak = Kontak(
      nama: 'Budi Santoso',
      email: 'budi@gmail.com',
      noHandphone: '08123456789',
      kategori: 'Teman',
    );

    expect(kontak.nama, 'Budi Santoso');
    expect(kontak.email, 'budi@gmail.com');
    expect(kontak.noHandphone, '08123456789');
    expect(kontak.kategori, 'Teman');
    expect(kontak.inisial, 'B');
  });

  testWidgets('Halaman Tambah Kontak menampilkan semua field formulir',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TambahKontakPage(),
      ),
    );
    await tester.pumpAndSettle();

    // Memastikan judul dan field tersedia
    expect(find.text('Tambah Kontak'), findsOneWidget);
    expect(find.text('Nama Lengkap'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('No Handphone'), findsOneWidget);
    expect(find.text('Kategori'), findsOneWidget);
    expect(find.text('Simpan Kontak'), findsOneWidget);
  });

  testWidgets('Validasi form Tambah Kontak saat field kosong',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TambahKontakPage(),
      ),
    );
    await tester.pumpAndSettle();

    // Tekan tombol Simpan Kontak tanpa mengisi data
    await tester.tap(find.text('Simpan Kontak'));
    await tester.pumpAndSettle();

    // Memastikan pesan error validasi muncul
    expect(find.text('Nama tidak boleh kosong'), findsOneWidget);
    expect(find.text('Email tidak boleh kosong'), findsOneWidget);
    expect(find.text('No HP wajib diisi'), findsOneWidget);
  });

  testWidgets('Halaman Tentang menampilkan profil pengembang sesuai identitas',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TentangPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tentang'), findsOneWidget);
    expect(find.text('Ibra Al Tabian'), findsOneWidget);
    expect(find.text('XII RPL B'), findsOneWidget);
    expect(find.text('SMK Negeri 5 Surakarta'), findsOneWidget);
  });
}
