import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/form/add_informasi_page.dart';

class ListInformasiPage extends StatefulWidget {
  const ListInformasiPage({super.key});

  @override
  State<ListInformasiPage> createState() => _ListInformasiPageState();
}

class _ListInformasiPageState extends State<ListInformasiPage> {
  final List<Map<String, dynamic>> informasi = [
    {
      "author": "Rakha Galih Nugraha S",
      "date": "12 Januari 2025",
      "title": "Open Recruitment Senior Residents XIII",
      "excerpt":
          "Formulir ini adalah langkah pertama bagi Dormitizen dan TeluTizen yang ingin menjadi bagian dari Senior Resident XIII...",
      "imageUrl":
          "https://via.placeholder.com/300x150", // ganti dengan URL gambar asli
    },
    {
      "author": "Iksan Oktav risandy",
      "date": "19 Desember 2024",
      "title": "Open Recruitment Senior Residents XII",
      "excerpt":
          "Formulir ini adalah langkah pertama bagi Dormitizen dan TeluTizen yang ingin menjadi bagian dari Senior Resident XII...",
      "imageUrl":
          "https://via.placeholder.com/300x150", // ganti dengan URL gambar asli
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarPage(
            title: 'Informasi',
            onAdd: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddInformasiPage(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: kGrey),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search),
                        SizedBox(width: 5),
                        Text('Cari')
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kGrey),
                  ),
                  child: const Icon(Icons.filter_alt),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: informasi.length,
              itemBuilder: (context, index) {
                final item = informasi[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/avatar.png'), // ganti path jika perlu
                              radius: 20,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['author'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(item['date'],
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text.rich(
                          TextSpan(
                            text: item['excerpt'],
                            children: [
                              TextSpan(
                                text: ' Baca Selengkapnya',
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['imageUrl'],
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
