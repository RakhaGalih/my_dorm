import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';
import 'package:my_dorm/components/faq_box.dart';
import 'package:my_dorm/components/filter_button.dart';
import 'package:my_dorm/components/search_container.dart';
import 'package:my_dorm/constant/constant.dart';
import 'package:my_dorm/models/faq_model.dart';

class FaqListPage extends StatelessWidget {
  const FaqListPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<FaqModel> daftarFAQ = [
      FaqModel(
          title: "Apa itu MyDorm?",
          content:
              "MyDorm merupakan inovasi yang di desain khusus untuk pengguna yang tinggal di asrama Telkom University. MyDorm merupakan penerapan solusi untuk memecahkan permasalahan utama yang dihadapi oleh penghuni asrama, yaitu masalah pencatatan keluar-masuk asrama dan manajemen kiriman paket. Dengan hadirnya aplikasi MyDorm, penghuni asrama dapat dengan mudah melacak keluar-masuk dengan lebih efisien dan akurat. Melalui aplikasi ini juga dapat dengan mudah mengetahui kiriman paket yang telah sampai dan dititipkan pada helpdesk.",
          hasImage: false,
      ),
      FaqModel(
          title: "Bagaimana cara mengetahui adanya paket?",
          content:
              "Aplikasi MyDorm memiliki fitur notifikasi yang dapat menginformasikan kepada pengguna apabila terdapat informasi penting yang perlu disampaikan, termasuk salah satunya paket yang datang. Paket yang datang akan ditangani langsung oleh Helpdesk maupun Senior Resident dan akan dikabarkan kepada pemilik paket melalui notifikasi.",
          hasImage: false
      ),
      FaqModel(
          title: "Bagaimana cara konfirmasi keluar-masuk?",
          content:
              '1. Pergi ke halaman beranda\n2. Pilih opsi "masuk/keluar"\n3. Klik opsi "masuk/keluar" dan anda suadh berhasil konfirmasi masuk/keluar',
          hasImage: true
          
      )
    ];
    return Scaffold(
        backgroundColor: kBgColor,
        body: Column(children: [
          AppBarPage(
            title: 'FAQ',
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          Column(
              children: List.generate(
                  daftarFAQ.length,
                  (index) => FaqBox(
                      title: daftarFAQ[index].title,
                      content: daftarFAQ[index].content,
                      hasImage: daftarFAQ[index].hasImage,)))
        ]));
  }
}
