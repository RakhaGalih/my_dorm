import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_drop_down.dart';
import 'package:my_dorm/components/form_photo_picker.dart';
import 'package:my_dorm/components/form_textfield.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/online_notification_service.dart';

class AddInformasiPage extends StatefulWidget {
  const AddInformasiPage({super.key});

  @override
  State<AddInformasiPage> createState() => _AddInformasiPageState();
}

class _AddInformasiPageState extends State<AddInformasiPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
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
                    const FormPhotoPicker(
                      title: 'informasi',
                    ),
                    const FormDropDown(title: 'Kategori', kategoriItems: [
                      'fasilitas asrama',
                      'event asrama',
                      'lingkungan asrama',
                      'peraturan asrama',
                    ]),
                    FormTextField(label: 'Judul', controller: _judulController),
                    FormTextField(
                      label: 'Deskripsi',
                      controller: _deskripsiController,
                      minLines: 3,
                    ),
                    GradientButton(
                        ontap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            MyNotificationService.sendNotificationToSelectedUser(
                                "fEV0o8wtQtyD-f0qEt0JTM:APA91bEusMjNO2sgAlbBkPl2Q8efGpTHDuqG6GjhaAq5h-z1e6H2jcUma-H3a3kZXpCCPFez7dwpVWC1ct_qeEt7zoXgASNc-Q6_WahI1FqTOwvENJhydek",
                                context,
                                _judulController.text,
                                _deskripsiController.text);
                            final snackBar = SnackBar(
                              content: const Text('Data berhasil ditambahkan!'),
                              action: SnackBarAction(
                                label: 'Batal',
                                textColor: kMain,
                                onPressed: () {
                                  // Some action if needed
                                },
                              ),
                            );

                            // Show the SnackBar
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
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
    );
  }
}
