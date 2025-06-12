import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_dorm/components/gradient_button.dart';
import 'package:my_dorm/components/login_textfield.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/screens/admin/nav_sr.dart';
import 'package:my_dorm/screens/auth/login_page.dart';
import 'package:my_dorm/screens/auth/pilih_role.dart';
import 'package:my_dorm/screens/dormitizen/home_dormitizen.dart';
import 'package:my_dorm/service/http_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String error = "";
  bool _showSpinner = false;

  Future<void> _login() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> response = {};
    try {
      Map<String, dynamic> data = {
        'username': _usernameController.text,
        'password': _passwordController.text,
      };
      response = await postData("/login", data);
      String token = response['accessToken']; // Ambil token dari response
      await saveToken(token, response['user_type']);
      if (mounted) {
        if (response['user_type'] == 'senior_resident') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NavbarSR()));
        } else if (response['user_type'] == 'dormitizen') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeDormitizen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PIlihRole()));
        }
      }
      print('berhasil login!');
      String? accessToken = await getToken();
      print(accessToken);
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

  Future<void> _register() async {
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> response = {};
    try {
      Map<String, dynamic> data = {
        'username': _usernameController.text,
        'password': _passwordController.text,
        'nim': _nimController.text,
        'nama': _namaController.text,
      };
      response = await postData("/dormitizen/register", data);
      print('berhasil daftar!');
      await _login();
    } catch (e) {
      print(response);
      setState(() {
        _showSpinner = false;
        error = e.toString();
      });
      print('Register error: $e');
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(gradient: kGradientMain),
                child: SafeArea(
                    bottom: false,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('images/bg-asrama-wide.png',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover),
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'images/dorm-logo-bg-remove.png',
                          width: 80,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login',
                          style: kBoldTextStyle.copyWith(fontSize: 30),
                        ),
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      LoginTextField(
                          label: 'Username',
                          controller: _usernameController,
                          isPassword: false),
                      const SizedBox(
                        height: 20,
                      ),
                      LoginTextField(
                          label: 'Password',
                          controller: _passwordController,
                          isPassword: true),
                      const SizedBox(
                        height: 20,
                      ),
                      LoginTextField(
                          label: 'NIM',
                          controller: _nimController,
                          isPassword: false),
                      const SizedBox(
                        height: 20,
                      ),
                      LoginTextField(
                          label: 'Nama',
                          controller: _namaController,
                          isPassword: false),
                      const SizedBox(
                        height: 42,
                      ),
                      GradientButton(
                        title: 'Register',
                        ontap: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await _register();
                          }
                        },
                      ),
                      if (error != "")
                        const SizedBox(
                          height: 8,
                        ),
                      if (error != "")
                        Text(
                          error,
                          textAlign: TextAlign.center,
                          style: kSemiBoldTextStyle.copyWith(
                              color: const Color(0xFFCD1A1A)),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sudah ada akun? ',
                              style: kRegularTextStyle.copyWith(fontSize: 16),
                            ),
                            Text(
                              'Login',
                              style: kBoldTextStyle.copyWith(
                                  fontSize: 16, color: kMain),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
