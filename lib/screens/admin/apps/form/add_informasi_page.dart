import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_drop_down.dart';
import 'package:my_dorm/components/form_photo_picker.dart';
import 'package:my_dorm/components/form_textfield.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/http_service.dart';

class AddInformasiPage extends StatefulWidget {
  const AddInformasiPage({super.key});

  @override
  State<AddInformasiPage> createState() => _AddInformasiPageState();
}

class _AddInformasiPageState extends State<AddInformasiPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? gambar;
  String? selectedKategori;

  String error = "";
  bool _showSpinner = false;

  Future<void> _addInformasi() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    dynamic response = {};
    try {
      Map<String, String> data = {
        'kategori': selectedKategori!,
        'judul': _judulController.text,
        'isi': _deskripsiController.text,
      };
      response = await postDataTokenWithImage("/berita", data, gambar);
      print('berhasil tambah laporan!');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Column(
          children: [
            const AppBarPage(title: 'Tambah Informasi'),
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
                      FormPhotoPicker(
                        title: 'informasi',
                        onImageSelected: (selectedImage) {
                          // Handle the selected image here
                          if (selectedImage != null) {
                            print('Selected image path: ${selectedImage.path}');
                          } else {
                            print('Image cleared');
                          }
                          setState(() {
                            gambar = selectedImage;
                          });
                        },
                      ),
                      FormDropDown(
                          title: 'Kategori',
                          kategoriItems: const [
                            'fasilitas asrama',
                            'event asrama',
                            'lingkungan asrama',
                            'peraturan asrama',
                          ],
                          onItemSelected: (selectedItem) {
                            // Handle the selected item here
                            print('Selected item: $selectedItem');
                            setState(() {
                              selectedKategori = selectedItem;
                            });
                          }),
                      FormTextField(
                          label: 'Judul', controller: _judulController),
                      FormTextField(
                        label: 'Deskripsi',
                        controller: _deskripsiController,
                        minLines: 3,
                      ),
                      GradientButton(
                          ontap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (selectedKategori!.isNotEmpty &&
                                  gambar != null) {
                                try {
                                  await _addInformasi();

                                  // Create the SnackBar
                                  const snackBar = SnackBar(
                                    content: Text('Data berhasil ditambahkan!'),
                                  );

                                  // Show the SnackBar
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.pop(context, 'sesuatu');
                                } catch (e) {
                                  print(e);
                                }
                              }
                            }
                          },
                          title: 'Tambah')
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
