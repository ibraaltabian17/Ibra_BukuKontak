import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MY APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buku Kontak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DefaultTabController(
        length: 2,
        child: MyHomePage(),
      ),
    );
  }
}

// HALAMAN UTAMA
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Menyimpan data kontak awal untuk pengujian
  List<Kontak> items = [
    Kontak(
      id: 'kontak_1',
      nama: 'Budi Santoso',
      email: 'budi@gmail.com',
      noHandphone: '081234567890',
      kategori: 'Teman',
    ),
    Kontak(
      id: 'kontak_2',
      nama: 'Annisa Rahma',
      email: 'annisa@gmail.com',
      noHandphone: '089876543210',
      kategori: 'Keluarga',
    ),
    Kontak(
      id: 'kontak_3',
      nama: 'Citra Dewi',
      email: 'citra@gmail.com',
      noHandphone: '082134567891',
      kategori: 'Kerja',
    ),
  ];

  // StreamController untuk pencarian real-time
  final StreamController<String> _searchController =
      StreamController<String>.broadcast();
  String _currentQuery = '';

  @override
  void dispose() {
    _searchController.close();
    super.dispose();
  }

  // FUNGSI UNTUK MEMBUKA HALAMAN TAMBAH KONTAK
  Future<void> tambahKontak() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahKontakPage(),
      ),
    );

    // Jika ada data kontak yang dikirim kembali
    if (hasil != null && hasil is Kontak) {
      setState(() {
        items.add(hasil);
      });
      _searchController.add(_currentQuery);
      DefaultTabController.of(context).animateTo(0);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kontak "${hasil.nama}" berhasil ditambahkan'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // FUNGSI UNTUK MENGEDIT KONTAK
  Future<void> editKontak(Kontak kontak) async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditKontakPage(kontak: kontak),
      ),
    );

    if (hasil != null && hasil is Kontak) {
      setState(() {
        final index = items.indexWhere((item) => item.id == hasil.id);
        if (index != -1) {
          items[index] = hasil;
        }
      });
      _searchController.add(_currentQuery);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kontak "${hasil.nama}" berhasil diperbarui'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // FUNGSI UNTUK MENGHAPUS KONTAK DENGAN KONFIRMASI DIALOG
  Future<void> hapusKontak(Kontak kontak) async {
    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah Anda yakin ingin menghapus kontak "${kontak.nama}"?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    // Jika pengguna memilih "Hapus"
    if (konfirmasi == true) {
      setState(() {
        items.removeWhere((item) => item.id == kontak.id);
      });
      _searchController.add(_currentQuery);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kontak "${kontak.nama}" berhasil dihapus'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('BUKU KONTAK'),

        // TAB BAR
        bottom: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.account_circle),
              text: 'Kontak',
            ),
            Tab(
              icon: Icon(Icons.star),
              text: 'Favorit',
            ),
          ],
        ),
      ),

      // DRAWER
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'BUKU KONTAK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            // MENU KONTAK
            ListTile(
              leading: const Icon(Icons.contact_page),
              title: const Text('Kontak'),
              onTap: () {
                DefaultTabController.of(context).animateTo(0);
                Navigator.pop(context);
              },
            ),

            // MENU TAMBAH KONTAK
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Tambah Kontak'),
              onTap: () {
                Navigator.pop(context);
                tambahKontak();
              },
            ),

            // MENU FAVORIT
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorit'),
              onTap: () {
                DefaultTabController.of(context).animateTo(1);
                Navigator.pop(context);
              },
            ),

            // MENU TENTANG
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TentangPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // TAB BAR VIEW
      body: TabBarView(
        children: [
          // TAB KONTAK
          daftarKontak(),

          // TAB FAVORIT
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Dhani Arrgiawan Widiyatmoko'),
            subtitle: Text(
              'dhani@gmail.com\n'
              '0812345678901',
            ),
          ),
        ],
      ),

      // FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tambahKontak();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // WIDGET DAFTAR KONTAK
  Widget daftarKontak() {
    return Column(
      children: [
        // TEXTFIELD PENCARIAN
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Cari Kontak',
              hintText: 'Cari berdasarkan nama atau kategori...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (teks) {
              _currentQuery = teks;
              _searchController.add(teks);
            },
          ),
        ),

        // STREAM BUILDER UNTUK DAFTAR KONTAK REAL-TIME
        Expanded(
          child: StreamBuilder<String>(
            stream: _searchController.stream,
            initialData: '',
            builder: (context, snapshot) {
              final query = (snapshot.data ?? '').toLowerCase().trim();

              // Filter kontak berdasarkan nama ATAU kategori
              final filteredList = items.where((kontak) {
                final namaMatch = kontak.nama.toLowerCase().contains(query);
                final kategoriMatch =
                    (kontak.kategori ?? '').toLowerCase().contains(query);
                return namaMatch || kategoriMatch;
              }).toList();

              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada kontak',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              if (filteredList.isEmpty) {
                return const Center(
                  child: Text(
                    'Kontak tidak ditemukan',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final kontak = filteredList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    elevation: 1.5,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          kontak.nama.isNotEmpty
                              ? kontak.nama[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(
                        kontak.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${kontak.email}\n'
                        '${kontak.noHandphone}\n'
                        'Kategori: ${kontak.kategori ?? 'Tanpa kategori'}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TOMBOL EDIT
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: 'Edit Kontak',
                            onPressed: () {
                              editKontak(kontak);
                            },
                          ),
                          // TOMBOL DELETE
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Hapus Kontak',
                            onPressed: () {
                              hapusKontak(kontak);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// HALAMAN TAMBAH KONTAK
class TambahKontakPage extends StatefulWidget {
  const TambahKontakPage({super.key});

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil input
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noHandphoneController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    noHandphoneController.dispose();
    kategoriController.dispose();
    super.dispose();
  }

  // FUNGSI SIMPAN KONTAK
  void simpanKontak() {
    Kontak kontak = Kontak(
      nama: namaController.text.trim(),
      email: emailController.text.trim(),
      noHandphone: noHandphoneController.text.trim(),
      kategori: kategoriController.text.trim().isEmpty
          ? null
          : kategoriController.text.trim(),
    );

    // Mengirim data kontak kembali ke halaman sebelumnya
    Navigator.pop(context, kontak);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Tambah Kontak'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NAMA
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // EMAIL
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus menggunakan karakter @';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // NOMOR HANDPHONE
              TextFormField(
                controller: noHandphoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No. Handphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor handphone tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'Nomor handphone hanya boleh berupa angka';
                  }
                  if (value.trim().length < 10) {
                    return 'Nomor handphone minimal 10 digit';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // KATEGORI
              TextFormField(
                controller: kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (contoh: Keluarga, Teman, Kerja)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),

              const SizedBox(height: 25),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      simpanKontak();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// HALAMAN EDIT KONTAK
class EditKontakPage extends StatefulWidget {
  final Kontak kontak;
  const EditKontakPage({super.key, required this.kontak});

  @override
  State<EditKontakPage> createState() => _EditKontakPageState();
}

class _EditKontakPageState extends State<EditKontakPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController namaController;
  late final TextEditingController emailController;
  late final TextEditingController noHandphoneController;
  late final TextEditingController kategoriController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.kontak.nama);
    emailController = TextEditingController(text: widget.kontak.email);
    noHandphoneController =
        TextEditingController(text: widget.kontak.noHandphone);
    kategoriController =
        TextEditingController(text: widget.kontak.kategori ?? '');
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    noHandphoneController.dispose();
    kategoriController.dispose();
    super.dispose();
  }

  // FUNGSI SIMPAN PERUBAHAN
  void simpanPerubahan() {
    final kontakBaru = Kontak(
      id: widget.kontak.id,
      nama: namaController.text.trim(),
      email: emailController.text.trim(),
      noHandphone: noHandphoneController.text.trim(),
      kategori: kategoriController.text.trim().isEmpty
          ? null
          : kategoriController.text.trim(),
    );

    // Mengirim data kontak yang telah diperbarui kembali ke halaman sebelumnya
    Navigator.pop(context, kontakBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Edit Kontak'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NAMA
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // EMAIL
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus menggunakan karakter @';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // NOMOR HANDPHONE
              TextFormField(
                controller: noHandphoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No. Handphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor handphone tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'Nomor handphone hanya boleh berupa angka';
                  }
                  if (value.trim().length < 10) {
                    return 'Nomor handphone minimal 10 digit';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              // KATEGORI
              TextFormField(
                controller: kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (contoh: Keluarga, Teman, Kerja)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),

              const SizedBox(height: 25),

              // TOMBOL SIMPAN PERUBAHAN
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      simpanPerubahan();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// HALAMAN TENTANG
class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Tentang'),
      ),
      body: const Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Ibra Al Tabian',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'XII RPL B',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'SMK Negeri 5 Surakarta',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CLASS KONTAK
class Kontak {
  static int _counter = 100;
  final String id;
  String nama;
  String email;
  String noHandphone;
  String? kategori;

  Kontak({
    String? id,
    required this.nama,
    required this.email,
    required this.noHandphone,
    this.kategori,
  }) : id = id ??
            'kontak_${++_counter}_${DateTime.now().microsecondsSinceEpoch}';
}
