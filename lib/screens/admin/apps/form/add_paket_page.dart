import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_date_time_picker.dart';
import 'package:my_dorm/components/form_photo_picker.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/http_service.dart';

class AddPaketPage extends StatefulWidget {
  const AddPaketPage({super.key});

  @override
  State<AddPaketPage> createState() => _AddPaketPageState();
}

class _AddPaketPageState extends State<AddPaketPage> {
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _kamarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedDormitizen;
  final List<Map<String, dynamic>> dormitizenDataList = [];
  String error = "";
  String waktu = "";
  File? gambar;
  bool _showSpinner = false;

  Future<void> _addPaket() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    dynamic response = {};
    try {
      Map<String, String> data = {
        'status_pengambilan': 'belum',
        'waktu_tiba': waktu,
        'dormitizen_id': selectedDormitizen!,
      };
      response = await postDataTokenWithImage("/paket", data, gambar);
      print('berhasil tambah laporan!');
      if (mounted) {
        Navigator.pop(context, 'sesuatu');
      }

      print(response['message']);
    } catch (e) {
      setState(() {
        _showSpinner = false;
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
            const AppBarPage(title: 'Tambah Paket'),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: _kamarController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) async {
                          // Reset selectedDormitizen when the room number changes
                          if (_kamarController.text.length == 3) {
                            await searchDormitizen(_kamarController.text);
                          }
                        },
                        decoration:
                            basicInputDecoration("Nomor kamar").copyWith(
                          suffixIcon: IconButton(
                            onPressed: () async {
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
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: DropdownButtonFormField<String>(
                          style: kMediumTextStyle.copyWith(
                              fontSize: 16, color: Colors.black),
                          decoration: basicInputDecoration("Pilih Dormitizen"),
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
                      FormPhotoPicker(
                        title: 'paket',
                        onImageSelected: (selectedImage) {
                          // Handle the selected image here
                          if (selectedImage != null) {
                            gambar = selectedImage;
                            print('Selected image path: ${selectedImage.path}');
                          } else {
                            print('Image cleared');
                          }
                        },
                      ),
                      FormDatePicker(
                        onDateTimeSelected: (selectedDateTime) {
                          // Handle the combined DateTime here
                          waktu = selectedDateTime.toString();
                          print('Selected DateTime: $selectedDateTime');
                        },
                      ),
                      GradientButton(
                          ontap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (selectedDormitizen == null ||
                                  gambar == null ||
                                  waktu.isEmpty) {
                                setState(() {
                                  error = "Semua field harus diisi!";
                                });
                                print(
                                    'Selected Dormitizen: $selectedDormitizen');
                                print('Selected Image: $gambar');
                                return;
                              } else {
                                print(
                                    'Selected Dormitizen: $selectedDormitizen');
                                print('Selected Image: $gambar');
                                await _addPaket();
                              }
                              const snackBar = SnackBar(
                                content: Text('Data berhasil ditambahkan!'),
                              );

                              // Show the SnackBar
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          title: 'Kirim')
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
