import 'package:intl/intl.dart';

String getFormattedDate(String date) {
  // Format: Hari, Tanggal Bulan Tahun
  DateTime parsedDate = DateTime.parse(date);
  String formattedDate = DateFormat('EEEE, d MMMM y', 'id_ID').format(parsedDate);

  return formattedDate;
}