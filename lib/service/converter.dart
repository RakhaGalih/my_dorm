import 'package:intl/intl.dart';

String getFormattedDate(String date) {
  // Format: Hari, Tanggal Bulan Tahun
  try {
    DateTime parsedDate = DateTime.parse(date);
    String formattedDate =
        DateFormat('EEEE, d MMMM y', 'id_ID').format(parsedDate);

    return formattedDate;
  } catch (e) {
    print('Error parsing date: $e');
    return 'Data tidak valid';
  }
}

String getFormattedTime() {
  DateTime sekarang = DateTime.now();
  int jam = sekarang.hour;
  if (jam >= 4 && jam < 10) {
    return 'pagi';
  } else if (jam >= 10 && jam < 15) {
    return 'siang';
  } else if (jam >= 15 && jam < 18) {
    return 'sore';
  } else {
    return 'malam';
  }
}
