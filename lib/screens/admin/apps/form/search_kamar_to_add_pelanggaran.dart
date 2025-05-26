import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk FilteringTextInputFormatter
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/apps/form/add_pelanggaran_page.dart';
import 'package:my_dorm/service/http_service.dart';

class SearchKamarToAddPelanggaran extends StatefulWidget {
  const SearchKamarToAddPelanggaran({super.key});

  @override
  State<SearchKamarToAddPelanggaran> createState() =>
      _SearchKamarToAddPelanggaranState();
}

class _SearchKamarToAddPelanggaranState
    extends State<SearchKamarToAddPelanggaran> {
  List<Map<String, dynamic>> dormitizens = [];
  final TextEditingController _kamarController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error = "";
  bool _showSpinner = false;

  Future<void> searchDormitizen(String nomorKamar) async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      String? token = await getToken();
      var response = await getDataToken('/user/$nomorKamar', token!);

      if (response['response'] != null) {
        setState(() {
          dormitizens = (response['response'] as List)
              .map((item) => item as Map<String, dynamic>)
              .toList();
        });
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
            const AppBarPage(title: 'Tambah Pelanggaran'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _kamarController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Nomor Kamar',
                            hintText: 'Masukkan nomor kamar',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: kMain, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            floatingLabelStyle: TextStyle(
                              color: _formKey.currentState?.validate() == false
                                  ? Colors.red
                                  : kMain,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nomor kamar tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        GradientButton(
                          ontap: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await searchDormitizen(_kamarController.text);
                              if (dormitizens.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddPelanggaranPage(
                                            // Kirim semua data hasil pencarian
                                            ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Data Dormitizen tidak ditemukan')),
                                );
                              }
                            }
                          },
                          title: 'Cari ',
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
