import 'package:flutter/material.dart';
import 'package:my_dorm/components/appbar_page.dart';

class DetailImagePage extends StatefulWidget {
  final String imagepath;
  const DetailImagePage({super.key, required this.imagepath});

  @override
  State<DetailImagePage> createState() => _DetailImagePageState();
}

class _DetailImagePageState extends State<DetailImagePage> {
  // sementara pakai image path
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      AppBarPage(
        title: 'Detail Gambar',
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Image.asset(
          widget.imagepath,
          height: 600,
          width: double.maxFinite,
          fit: BoxFit.cover,
        ),
      )
    ]));
  }
}
