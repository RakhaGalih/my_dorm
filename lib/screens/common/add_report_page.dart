import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_textfield.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/http_service.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String error = "";
  bool _showSpinner = false;

  Future<void> _addReport() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    dynamic response = {};
    try {
      Map<String, dynamic> data = {
        'judul': _judulController.text,
        'isi': _deskripsiController.text,
      };
      response = await postDataToken("/laporan", data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Column(
          children: [
            const AppBarPage(title: 'Tambah Laporan'),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Icon(
                        FluentIcons.warning_24_filled,
                        color: kRed,
                        size: MediaQuery.of(context).size.width * 0.3,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
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
                              await _addReport();
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
