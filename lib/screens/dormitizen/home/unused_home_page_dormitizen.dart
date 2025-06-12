import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_home.dart';
import 'package:my_dorm/components/home_calendar.dart';
import 'package:my_dorm/components/home_carousel.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/service/http_service.dart';

class HomePageDormitizenUnused extends StatefulWidget {
  const HomePageDormitizenUnused({super.key});

  @override
  State<HomePageDormitizenUnused> createState() =>
      _HomePageDormitizenUnusedState();
}

class _HomePageDormitizenUnusedState extends State<HomePageDormitizenUnused> {
  String nama = 'loading...';
  String statusKamar = '';
  String error = "";
  bool _showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInfo();
  }

  void _getInfo() async {
    error = "";
    setState(() {
      _showSpinner = true;
    });
    Map<String, dynamic> response = {};
    try {
      String? token = await getToken();
      response = await getDataToken("/user", token!);
      print(response);
      statusKamar = response['data'][0]['kamar']['status'];
      nama = response['data'][0]['nama'];
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
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Stack(
        children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarHome(
                  titleContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat pagi,',
                    style: kSemiBoldTextStyle.copyWith(
                        color: kWhite, fontSize: 15),
                  ),
                  Text(
                    nama,
                    style: kBoldTextStyle.copyWith(color: kWhite, fontSize: 20),
                  ),
                ],
              )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Informasi',
                  style:
                      kSemiBoldTextStyle.copyWith(fontSize: 14, color: kWhite),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const HomeCarousel(),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: kRed,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(children: [
                  const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: kWhite,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Kunci Anda Sekarang berada di ',
                    style:
                        kRegularTextStyle.copyWith(color: kWhite, fontSize: 12),
                  ),
                  Text(
                    (statusKamar == '')
                        ? 'Loading...'
                        : (statusKamar == 'terkunci')
                            ? 'Helpdesk'
                            : 'Kamar Anda',
                    style: kBoldTextStyle.copyWith(color: kWhite, fontSize: 12),
                  )
                ]),
              ),
              const HomeCalendar(),
              const SizedBox(
                height: 150,
              )
            ],
          ),
        ],
      ),
    );
  }
}
