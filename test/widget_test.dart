import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_design/main.dart';

void main() {
  testWidgets('Menampilkan daftar kontak awal', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Memastikan kontak awal muncul
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Annisa Rahma'), findsOneWidget);
    expect(find.text('Citra Dewi'), findsOneWidget);
  });

  testWidgets('Pengujian fitur Edit Kontak', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tekan tombol edit pertama (untuk Budi Santoso)
    final editButtons = find.byIcon(Icons.edit);
    expect(editButtons, findsWidgets);
    await tester.tap(editButtons.first);
    await tester.pumpAndSettle();

    // Pastikan halaman Edit Kontak muncul dengan data awal
    expect(find.text('Edit Kontak'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('Simpan Perubahan'), findsOneWidget);

    // Ubah nama kontak
    final namaField = find.widgetWithText(TextFormField, 'Nama Lengkap');
    await tester.enterText(namaField, 'Budi Pratama');
    await tester.pumpAndSettle();

    // Tekan Simpan Perubahan
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    // Verifikasi kembali ke daftar kontak dan nama telah berubah
    expect(find.text('Budi Pratama'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsNothing);
  });

  testWidgets('Pengujian fitur Delete Kontak dengan Konfirmasi Dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Tekan tombol delete untuk kontak pertama
    final deleteButtons = find.byIcon(Icons.delete);
    expect(deleteButtons, findsWidgets);
    await tester.tap(deleteButtons.first);
    await tester.pumpAndSettle();

    // Pastikan dialog konfirmasi muncul dengan opsi Batal dan Hapus
    expect(find.text('Konfirmasi Hapus'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.text('Hapus'), findsOneWidget);

    // Uji opsi Batal
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    // Kontak masih ada di daftar
    expect(find.text('Budi Santoso'), findsOneWidget);

    // Tekan delete lagi lalu pilih Hapus
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();

    // Kontak telah terhapus
    expect(find.text('Budi Santoso'), findsNothing);
  });

  testWidgets('Pengujian Pencarian dan Edit/Delete pada hasil pencarian',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Cari "Annisa"
    final searchField = find.widgetWithText(TextField, 'Cari Kontak');
    await tester.enterText(searchField, 'Annisa');
    await tester.pumpAndSettle();

    // Hanya Annisa yang muncul
    expect(find.text('Annisa Rahma'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsNothing);

    // Edit kontak hasil pencarian
    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();

    expect(find.text('Annisa Rahma'), findsOneWidget);
    final namaField = find.widgetWithText(TextFormField, 'Nama Lengkap');
    await tester.enterText(namaField, 'Annisa Kusumastuti');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    // Bersihkan pencarian
    await tester.enterText(searchField, '');
    await tester.pumpAndSettle();

    // Kontak yang terupdate harus Annisa Kusumastuti, dan kontak lain tetap utuh
    expect(find.text('Annisa Kusumastuti'), findsOneWidget);
    expect(find.text('Budi Santoso'), findsOneWidget);
  });
}
