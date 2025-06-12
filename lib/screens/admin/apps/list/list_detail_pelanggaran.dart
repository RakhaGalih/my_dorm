import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/components/outline_button.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/form/add_pelanggaran_page.dart';
import 'package:my_dorm/screens/admin/apps/form/edit_pelanggaran_page.dart';
import 'package:my_dorm/service/http_service.dart';
import 'package:my_dorm/service/image_service.dart';

class ListDetailPelanggaranPage extends StatefulWidget {
  final String dormitizenId;
  final String noKamar;
  const ListDetailPelanggaranPage(
      {super.key, required this.dormitizenId, required this.noKamar});

  @override
  State<ListDetailPelanggaranPage> createState() =>
      _ListDetailPelanggaranPageState();
}

class _ListDetailPelanggaranPageState extends State<ListDetailPelanggaranPage> {
  List<Map<String, dynamic>> pelanggarans = [];
  String error = "";
  bool _showSpinner = true;

  @override
  void initState() {
    super.initState();
    getPelanggaranByUserId();
  }

  Future<void> refreshData() async {
    setState(() {
      _showSpinner = true;
      pelanggarans.clear();
    });
    await getPelanggaranByUserId();
  }

  String formatTanggal(String tanggal) {
    DateTime dateTime = DateTime.parse(tanggal).toLocal();
    return DateFormat('dd MMM yyyy • HH:mm').format(dateTime);
  }

  Future<void> getPelanggaranByUserId() async {
    error = "";
    try {
      String? token = await getToken();
      var response = await getDataToken(
          '/pelanggaran/user/${widget.dormitizenId}', token!);
      List<Map<String, dynamic>> parsedData = (response['data'] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
      print(response);
      setState(() {
        pelanggarans = parsedData;
      });
    } catch (e) {
      print(e);
      setState(() {
        error = "Error: $e";
      });
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  void _deletePelanggaran(String pelanggaranId) async {
    setState(() {
      _showSpinner = true;
    });
    try {
      var response = await deleteDataToken('/pelanggaran/$pelanggaranId');
      if (response['message'] == 'Pelanggaran berhasil dihapus') {
        setState(() {
          pelanggarans.removeWhere(
              (pelanggaran) => pelanggaran['pelanggaran_id'] == pelanggaranId);
        });
        Navigator.pop(context);
      } else {
        setState(() {
          error = "Gagal menghapus pelanggaran";
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        error = "Error: $e";
      });
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  void _showDialogDelete(String pelanggaranId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          backgroundColor: kWhite,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ingin menghapus pelanggaran ini?'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        ontap: () {
                          _deletePelanggaran(pelanggaranId);
                        },
                        title: "IYA",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlineButton(
                        ontap: () {
                          Navigator.pop(context);
                        },
                        title: "TIDAK",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBarPage(
            title: 'Detail Pelanggaran',
            onAdd: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPelanggaranPage(),
                ),
              );
              if (result != null) {
                refreshData();
              }
            },
          ),
          if (_showSpinner)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: CircularProgressIndicator(
                color: kMain,
              )),
            )
          else if (error.isNotEmpty)
            Center(
              child: Text(
                error,
                style: kMediumTextStyle.copyWith(color: Colors.red),
              ),
            )
          else if (pelanggarans.isEmpty)
            Center(
              child: Text(
                "Tidak ada pelanggaran yang ditemukan",
                style: kMediumTextStyle.copyWith(color: Colors.grey),
              ),
            )
          else
            const SizedBox(height: 4),
          if (pelanggarans.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 12),
              child: Text(
                "List Pelanggaran ${pelanggarans[0]['pelanggar']['nama']} ",
                style: kBoldTextStyle,
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: pelanggarans.length,
              itemBuilder: (context, index) {
                final pelanggaran = pelanggarans[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ShadowContainer(
                    onLongPress: () {
                      _showDialogDelete(pelanggaran['pelanggaran_id']);
                    },
                    child: Stack(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gambar Lokal Menggunakan Image.asset
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: MyNetworkImage(
                                  imageURL:
                                      'https://mydorm-mobile-backend-production-5f66.up.railway.app/images/foto-profil/${pelanggaran['pelanggar']['gambar'].replaceAll('_', '-')}',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Informasi Pelanggaran
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pelanggaran['pelanggar']['nama'],
                                      style:
                                          kBoldTextStyle.copyWith(fontSize: 15),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          formatTanggal(pelanggaran['waktu']),
                                          style: kMediumTextStyle.copyWith(
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text("Kamar: ${widget.noKamar}",
                              style: kMediumTextStyle.copyWith(fontSize: 15)),
                          const SizedBox(height: 4),
                          Text("Kategori: ${pelanggaran['kategori']}",
                              style: kMediumTextStyle.copyWith(fontSize: 15)),
                          const SizedBox(height: 4),
                          Text("Bukti:",
                              style: kMediumTextStyle.copyWith(fontSize: 15)),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: MyNetworkImage(
                              imageURL:
                                  '$apiURL/images/pelanggaran/${pelanggaran['gambar']}',
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 1,
                        right: 1,
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPelanggaranPage(
                                  dormitizenName: pelanggaran['pelanggar']
                                      ['nama'],
                                  pelanggaranId: pelanggaran['pelanggaran_id'],
                                  dormitizenId: widget.dormitizenId,
                                  noKamar: widget.noKamar,
                                  kategori: pelanggaran['kategori'],
                                  waktu: pelanggaran['waktu'],
                                ),
                              ),
                            );
                            await refreshData();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: kGradientMain,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.pencil,
                                    size: 16,
                                    color: kWhite,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Edit",
                                    style: kBoldTextStyle.copyWith(
                                        color: kWhite, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
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
