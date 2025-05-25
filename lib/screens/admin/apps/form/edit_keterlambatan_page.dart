import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_textfield.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';

class EditKeterlambatanPage extends StatefulWidget {
  const EditKeterlambatanPage({super.key});

  @override
  State<EditKeterlambatanPage> createState() => _EditKeterlambatanPageState();
}

class _EditKeterlambatanPageState extends State<EditKeterlambatanPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        children: [
          const AppBarPage(title: 'Tambah Keterlambatan'),
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
                    FormTextField(label: 'Judul', controller: _judulController),
                    FormTextField(
                      label: 'Deskripsi',
                      controller: _deskripsiController,
                      minLines: 3,
                    ),
                    GradientButton(
                        ontap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {

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
                        },
                        title: 'Kirim')
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
