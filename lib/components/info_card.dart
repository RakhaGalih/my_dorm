// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/converter.dart';
import 'package:my_dorm/service/http_service.dart';
import 'package:my_dorm/service/image_service.dart';

class InformasiCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const InformasiCard({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<InformasiCard> createState() => _InformasiCardState();
}

class _InformasiCardState extends State<InformasiCard> {
  int _maxLines = 5;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage:
                      AssetImage('images/zee.png'), // ganti path jika perlu
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.item['nama_penulis'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(getFormattedDate(widget.item['updated_at']) ?? 'error',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.item['judul'] ?? 'error',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.item['isi'] ?? 'error',
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.item['isi'].toString().length > 100)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _maxLines = _maxLines == 5 ? 100 : 5;
                  });
                },
                child: Text(
                  (_maxLines == 5) ? 'Baca Selengkapnya' : 'Tutup',
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: MyNetworkImage(
                imageURL: '$apiURL/images/informasi/${widget.item['gambar']}',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
