import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/appbar_home.dart';
import 'package:my_dorm/components/profile_desc.dart';
import 'package:my_dorm/components/shadow_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/auth/login_page.dart';
import 'package:my_dorm/service/http_service.dart';

class ProfilPageDromitizen extends StatefulWidget {
  const ProfilPageDromitizen({super.key});

  @override
  State<ProfilPageDromitizen> createState() => _ProfilPageDromitizenState();
}

class _ProfilPageDromitizenState extends State<ProfilPageDromitizen> {
  String NIM = ' loading...';
  String status = 'loading...';
  String nama = 'loading...';
  String username = 'loading...';
  String prodi = 'loading...';
  String agama = 'loading...';
  String noHP = 'loading...';
  String noHPOrtu = 'loading...';
  String gedung = 'loading...';
  String noKamar = 'loading...';
  String error = "";
  bool _showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  void _getUser() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> response = {};
    try {
      String? token = await getToken();
      response = await getDataToken("/user", token!);
      print(response);
      NIM = response['data'][0]['nim'];
      status = response['user_type'];
      nama = response['data'][0]['nama'];
      username = response['data'][0]['username'];
      prodi = response['data'][0]['prodi'];
      agama = response['data'][0]['agama'];
      noHP = response['data'][0]['no_hp'];
      noHPOrtu = response['data'][0]['no_hp_ortu'];
      gedung =
          "${response['data'][0]['kamar']['gedung']['nama']} (${response['data'][0]['kamar']['gedung']['kode']})";
      noKamar = response['data'][0]['kamar']['nomor'];
    } catch (e) {
      setState(() {
        _showSpinner = false;
        error = "Email atau Password salah";
      });
      error = "${response['message']}";
      print('Login error: $e');
      print(response);
    }
    setState(() {
      _showSpinner = false;
    });
  }

  void _logout() async {
    String? accessToken = await getToken();
    String? role = await getRole();
    print(accessToken);
    print(role);
    error = "";
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> response = {};
    try {
      String? token = await getToken();
      response = await logout(token!);
      await removeToken();
      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
      print('berhasil logout!');
      String? accessToken = await getToken();
      String? role = await getRole();
      print(accessToken);
      print(role);
    } catch (e) {
      setState(() {
        _showSpinner = false;
        error = "Email atau Password salah";
      });
      error = "${response['message']}";
      print('Login error: $e');
      print(response);
    }
    setState(() {
      _showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Stack(children: [
            SizedBox(
              height: 250,
              child: Stack(children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(gradient: kGradientMain),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('images/bg-asrama-wide.png',
                      width: double.infinity, fit: BoxFit.cover),
                ),
              ]),
            ),
            Column(
              children: [
                AppBarHome(
                    titleContent: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil',
                      style:
                          kBoldTextStyle.copyWith(color: kWhite, fontSize: 20),
                    ),
                  ],
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.06,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      border: Border.all(color: kWhite, width: 2),
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                          image: AssetImage('images/dormitizen.png'),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      nama,
                      textAlign: TextAlign.center,
                      style: kSemiBoldTextStyle.copyWith(fontSize: 20),
                    )),
                Container(
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      gradient: kGradientMain,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      ProfileDesc(title: 'NIM', value: NIM),
                      ProfileDesc(title: 'Status', value: status),
                      ProfileDesc(title: 'Username', value: username),
                      ProfileDesc(title: 'Prodi', value: prodi),
                      ProfileDesc(title: 'Agama', value: agama),
                      ProfileDesc(title: 'No HP', value: noHP),
                      ProfileDesc(title: 'No HP Ortu', value: noHPOrtu),
                      ProfileDesc(title: 'Gedung', value: gedung),
                      ProfileDesc(title: 'No kamar', value: noKamar),
                    ],
                  ),
                ),
                ShadowContainer(
                  onTap: () {
                    confirmDialog(context, "Konfirmasi Logout",
                        "Apakah anda yakin ingin logout?", () {
                      _logout();
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(
                        FluentIcons.sign_out_24_filled,
                        color: kMain,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        'Keluar',
                        style: kSemiBoldTextStyle.copyWith(
                            fontSize: 14, color: kMain),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 120,
                )
              ],
            )
          ])),
    );
  }
}
