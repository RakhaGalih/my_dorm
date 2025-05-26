import 'package:intl/intl.dart';

String getFormattedDate(String date) {
  // Format: Hari, Tanggal Bulan Tahun
  try{
  DateTime parsedDate = DateTime.parse(date);
  String formattedDate = DateFormat('EEEE, d MMMM y', 'id_ID').format(parsedDate);

  return formattedDate;
  } catch (e) {
    print('Error parsing date: $e');
    return 'Data tidak valid';
  }
}