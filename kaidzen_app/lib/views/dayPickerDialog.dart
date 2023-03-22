
import 'package:flutter/material.dart';

class DayPickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const DayPickerDialog({Key? key, required this.initialDate}) : super(key: key);

  @override
  _DayPickerDialogState createState() => _DayPickerDialogState();
}

class _DayPickerDialogState extends State<DayPickerDialog> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pick a day'),
      content: SingleChildScrollView(
        child: YearPicker(
          selectedDate: _selectedDate,
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
          onChanged: (date) => setState(() => _selectedDate = date),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selectedDate),
          child: Text('OK'),
        ),
      ],
    );
  }
}
