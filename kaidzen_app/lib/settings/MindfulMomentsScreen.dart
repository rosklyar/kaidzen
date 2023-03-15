import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/NotificationService.dart';
import 'package:kaidzen_app/settings/Story.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/story_view.dart';

import '../views/dayPickerDialog.dart';

class MindfulMomentsScreen extends StatefulWidget {
  @override
  _MindfulMomentsScreenState createState() => _MindfulMomentsScreenState();
}

class _MindfulMomentsScreenState extends State<MindfulMomentsScreen> {
  late String _backgroundImage = 'assets/settings/reminder/on.png';
  bool _isReminderOn = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  RepeatType _selectedRepeatType = RepeatType.DAILY;

  @override
  _MindfulMomentsScreenState createState() => _MindfulMomentsScreenState();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    await prefs.setString('selectedDateTime', dateTime.toString());
    await prefs.setString('repeatType', _selectedRepeatType.toString());
    await prefs.setBool('reminderEnabled', _isReminderOn);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final reminderEnabled = prefs.getBool('reminderEnabled');
    if (reminderEnabled != null) {
      setState(() {
        _isReminderOn = reminderEnabled;
        _backgroundImage = _isReminderOn
            ? 'assets/settings/reminder/on.png'
            : 'assets/settings/reminder/off.png';
      });
    }

    final dateTimeString = prefs.getString('selectedDateTime');
    if (dateTimeString != null) {
      final dateTime = DateTime.parse(dateTimeString);
      setState(() {
        _selectedDate = dateTime;
        _selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      });
    }

    final repeatTypeString = prefs.getString('repeatType');
    if (repeatTypeString != null) {
      setState(() {
        _selectedRepeatType = RepeatType.values.firstWhere(
          (e) => e.toString() == repeatTypeString,
          orElse: () => RepeatType.DAILY,
        );
      });
    }
  }

  void _showDayPickerDialog() async {
    final DateTime? picked = await showDatePicker(
        context: this.context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      await _savePreferences();
      refreshReminderState();
    }
  }

  void _showTimePickerDialog() async {
    final time = await showTimePicker(
      context: this.context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
      await _savePreferences();
      refreshReminderState();
    }
  }

  void _showRepeatTypePickerDialog() async {
    final repeatType = await showDialog<RepeatType>(
      context: this.context,
      builder: (context) =>
          RepeatTypePickerDialog(initialRepeatType: _selectedRepeatType),
    );
    if (repeatType != null) {
      setState(() => _selectedRepeatType = repeatType);
      await _savePreferences();
      refreshReminderState();
    }
  }

  Widget _buildSettingRow(String label, Widget value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16.0),
            ),
            Row(
              children: [
                value,
                SizedBox(width: 16.0),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: SvgPicture.asset("assets/shevron-left-black.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: SvgPicture.asset("assets/settings/close_black_icon.svg"),
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil((_) => count++ >= 2);
              },
            )
          ],
          backgroundColor: Colors.white.withOpacity(0),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(30),
                //color: Colors.blue[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Set aside regular time for self-reflection and mindfulness to achieve greater results.',
                        style: Fonts.largeTextStyle),
                    SizedBox(height: 16),
                    Text(
                        'Use this time for planning your life, establishing meaningful goals, and focusing on the ones that matter the most.',
                        style: Fonts.largeTextStyle),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      _backgroundImage,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        _buildSettingRow(
                            'Remind me',
                            Text(DateFormat('MMM dd, yyyy')
                                .format(_selectedDate)),
                            _showDayPickerDialog),
                        Divider(height: 5),
                        _buildSettingRow(
                            'On time',
                            Text(_selectedTime.format(context)),
                            _showTimePickerDialog),
                        Divider(height: 5),
                        _buildSettingRow(
                            "Repeat",
                            Text(_selectedRepeatType != null
                                ? _selectedRepeatType.name
                                : "None"),
                            _showRepeatTypePickerDialog),
                        Divider(height: 5),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Reminder is ${_isReminderOn ? 'on' : 'off'}',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Switch(
                                  value: _isReminderOn,
                                  onChanged: (value) async {
                                    setState(() {
                                      _isReminderOn = value;
                                      _backgroundImage = value
                                          ? 'assets/settings/reminder/on.png'
                                          : 'assets/settings/reminder/off.png';
                                      refreshReminderState();
                                    });
                                    await _savePreferences();
                                  },
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void refreshReminderState() {
    if (_isReminderOn) {
      NotificationService
          .scheduleNotification(
              AppNotifications.REMINDER.id,
              "Time to sort up your goals",
              "",
              _selectedDate,
              _selectedTime,
              _selectedRepeatType);
    } else {
      NotificationService.cancelNotification(
          AppNotifications.REMINDER.id);
    }
  }
}

class RepeatTypePickerDialog extends StatefulWidget {
  final RepeatType initialRepeatType;

  const RepeatTypePickerDialog({Key? key, required this.initialRepeatType})
      : super(key: key);

  @override
  _RepeatTypePickerDialogState createState() => _RepeatTypePickerDialogState();
}

class _RepeatTypePickerDialogState extends State<RepeatTypePickerDialog> {
  late RepeatType _selectedRepeatType;

  @override
  void initState() {
    super.initState();
    _selectedRepeatType = widget.initialRepeatType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select repeat type'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<RepeatType>(
              title: const Text('Daily'),
              value: RepeatType.DAILY,
              groupValue: _selectedRepeatType,
              onChanged: (RepeatType? value) {
                setState(() {
                  _selectedRepeatType = value!;
                });
              },
            ),
            RadioListTile<RepeatType>(
              title: const Text('Weekly'),
              value: RepeatType.WEEKLY,
              groupValue: _selectedRepeatType,
              onChanged: (RepeatType? value) {
                setState(() {
                  _selectedRepeatType = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedRepeatType);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
