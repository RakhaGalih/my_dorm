import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_dorm/constant/constant.dart';

class FormDatePicker extends StatefulWidget {
  final ValueChanged<DateTime?>
      onDateTimeSelected; // Callback for combined DateTime

  const FormDatePicker({
    super.key,
    required this.onDateTimeSelected, // Initialize the DateTime callback
  });

  @override
  State<FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<FormDatePicker> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2017),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      _updateDateTime();
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
      _updateDateTime();
    }
  }

  void _updateDateTime() {
    if (selectedDate != null && selectedTime != null) {
      final DateTime combinedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      widget.onDateTimeSelected(combinedDateTime); // Call the DateTime callback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: basicInputDecoration('Tanggal'),
            child: Text(
              selectedDate == null
                  ? 'Pilih Tanggal'
                  : DateFormat('dd/MM/yyyy').format(selectedDate!),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () => _selectTime(context),
          child: InputDecorator(
            decoration: basicInputDecoration('Waktu'),
            child: Text(
              selectedTime == null
                  ? 'Pilih Waktu'
                  : selectedTime!.format(context),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
