import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/form_date_time_picker.dart';
import 'package:my_dorm/components/form_drop_down.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/http_service.dart';

class AddLogPage extends StatefulWidget {
  const AddLogPage({super.key});

  @override
  State<AddLogPage> createState() => _AddLogPageState();
}

class _AddLogPageState extends State<AddLogPage> {
  final List<Map<String, dynamic>> dormitizenDataList = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kamarController = TextEditingController();
  String waktu = "";
  String? selectedDormitizen;
  String? selectedKategori;
  String error = "";
  bool _showSpinner = false;
  Future<void> searchDormitizen(String nomorKamar) async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    try {
      dormitizenDataList.clear();
      String? token = await getToken();
      var response = await getDataToken('/user/$nomorKamar', token!);

      if (response['response'] != null) {
        List<Map<String, dynamic>> dormitizens = (response['response'] as List)
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
            const AppBarPage(title: 'Tambah Log Manual'),
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
                        decoration: basicInputDecoration("Nomor kamar").copyWith(
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
                      FormDropDown(
                        kategoriItems: const ['Masuk', 'Keluar'],
                        title: 'Status',
                        onItemSelected: (selectedItem) {
                          // Handle the selected item here
                          print('Selected item: $selectedItem');
                        },
                      ),
                      FormDatePicker(
                        onDateTimeSelected: (selectedDateTime) {
                          // Handle the combined DateTime here
                          print('Selected DateTime: $selectedDateTime');
                        },
                      ),
                      GradientButton(
                          ontap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              try {
                                //_addInformasi();
        
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
      ),
    );
  }
}
