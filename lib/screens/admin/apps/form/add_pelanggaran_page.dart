import 'dart:io';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_date_time_picker.dart';
import 'package:my_dorm/components/form_drop_down.dart';
import 'package:my_dorm/components/form_photo_picker.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/http_service.dart';

class AddPelanggaranPage extends StatefulWidget {
  const AddPelanggaranPage({super.key});

  @override
  State<AddPelanggaranPage> createState() => _AddPelanggaranPageState();
}

class _AddPelanggaranPageState extends State<AddPelanggaranPage> {
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _kamarController = TextEditingController();
  final TextEditingController _waktuController = TextEditingController();
  File? gambar;
  final List<Map<String, dynamic>> dormitizenDataList = [];
  final _formKey = GlobalKey<FormState>();
  String waktu = "";
  String? selectedDormitizen;
  String? selectedKategori;

  String error = "";
  String infoSnackbar = "";
  bool _showSpinner = false;

  Future<void> _addPelanggaran() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    dynamic response = {};
    try {
      dev.log('gambar: ${gambar?.path}');
      Map<String, String> data = {
        'kategori': selectedKategori!,
        'waktu': waktu,
        'dormitizen_id': selectedDormitizen!,
      };
      dev.log('Data to be sent: $data');
      response = await postDataTokenWithFile("/pelanggaran", data, gambar);
      dev.log('Response from add pelanggaran: $response');
      if (mounted) {
        setState(() {
          infoSnackbar = 'Pelanggaran berhasil ditambahkan!';
        });
      } else {
        setState(() {
          infoSnackbar = 'Gagal menambahkan pelanggaran';
        });
      }
      print(response['message']);
    } catch (e) {
      setState(() {
        _showSpinner = false;
        infoSnackbar = 'Pelanggaran gagal ditambahkan!';
        error = "${response['message']}";
      });
      print('Login error: $e');
      print(response);
    }
    setState(() {
      _showSpinner = false;
    });
  }

  Future<void> searchDormitizen(String nomorKamar) async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      dormitizenDataList.clear();
      String? token = await getToken();
      var response = await getDataToken('/dormitizen/$nomorKamar', token!);

      if (response['data'] != null) {
        List<Map<String, dynamic>> dormitizens = (response['data'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        for (var dormitizen in dormitizens) {
          dormitizenDataList.add({
            'id': dormitizen['dormitizen_id'],
            'nama': dormitizen['nama'],
          });
        }
        print('Data Dormitizen: $dormitizens');
      } else {
        print('error: ${response['message']}');
        setState(() {
          error = "Data dormitizen tidak ditemukan.";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Column(
          children: [
            const AppBarPage(title: 'Tambah Pelanggaran'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _kamarController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration:
                              basicInputDecoration("Nomor kamar").copyWith(
                            suffixIcon: IconButton(
                              onPressed: () async {
                                print('Searching for dormitizen...');
                                await searchDormitizen(_kamarController.text);
                              },
                              icon: const Icon(Icons.search),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nomor kamar tidak boleh kosong';
                            }
                            return null;
                          },
                          onChanged: (value) async {
                            // Reset selectedDormitizen when the room number changes
                            if (_kamarController.text.length == 3) {
                              await searchDormitizen(_kamarController.text);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DropdownButtonFormField<String>(
                            style: kMediumTextStyle.copyWith(
                                fontSize: 16, color: Colors.black),
                            decoration:
                                basicInputDecoration("Pilih Dormitizen"),
                            value: selectedDormitizen,
                            icon: const Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            items: dormitizenDataList
                                .map((Map<String, dynamic> dormitizen) {
                              return DropdownMenuItem<String>(
                                value: dormitizen['id'].toString(),
                                child: Text(dormitizen['nama']),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedDormitizen = newValue;
                              });
                              print('Selected Dormitizen: $selectedDormitizen');
                            },
                          ),
                        ),
                        FormDropDown(
                          title: 'Kategori',
                          kategoriItems: const [
                            'Rokok',
                            'Terlambat',
                            'Vape',
                            'Alkohol',
                            'Barang Terlarang',
                            'Membawa Lawan Jenis ke dalam Kamar',
                            'Membawa Teman dari luar Gedung Asrama',
                          ],
                          onItemSelected: (selectedItem) {
                            selectedKategori = selectedItem;
                          },
                        ),
                        FormDatePicker(
                          onDateTimeSelected: (selectedDateTime) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(selectedDateTime!);
                            waktu = formattedDate;
                          },
                        ),
                        FormPhotoPicker(
                          title: 'Pelanggaran',
                          onImageSelected: (selectedImage) {
                            if (selectedImage != null) {
                              print(
                                  'Selected image path: ${selectedImage.path}');
                              setState(() {
                                gambar = selectedImage;
                              });
                            } else {
                              print('Image cleared');
                            }
                          },
                        ),
                        GradientButton(
                          ontap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (selectedDormitizen!.isNotEmpty &&
                                  waktu != "" &&
                                  gambar != null) {
                                try {
                                  await _addPelanggaran();

                                  // Create the SnackBar
                                  var snackBar = SnackBar(
                                    content: Text(infoSnackbar),
                                  );

                                  // Show the SnackBar
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.pop(context, 'success');
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                print(waktu);
                                print(selectedDormitizen);
                              }
                            } else {
                              print('Form is invalid');
                            }
                          },
                          title: 'Tambah Pelanggaran',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
