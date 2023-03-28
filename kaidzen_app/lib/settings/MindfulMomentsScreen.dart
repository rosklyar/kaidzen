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
  late String _backgroundImage = 'assets/settings/reminder/off.png';
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

  Widget _buildSettingRow(double screenWidth, String label, Widget value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04, horizontal: screenWidth * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Fonts.largeTextStyle,
            ),
            Row(
              children: [
                value,
                SizedBox(width: screenWidth * 0.04),
                Image.asset("assets/edit.png"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
          title: Text('Mindful moments', style: Fonts.screenTytleTextStyle),
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
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenWidth * 0.08,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenWidth * 0.025),
                    Text(
                      'Set aside regular time for self-reflection and mindfulness to achieve greater results.',
                      style: Fonts.largeTextStyle,
                    ),
                    SizedBox(height: screenWidth * 0.05),
                    Text(
                      'Use this time for planning your life, establishing meaningful goals, and focusing on the ones that matter the most.',
                      style: Fonts.largeTextStyle,
                    ),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenWidth * 0.02,
                    ),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        _buildSettingRow(
                          screenWidth,
                          'Remind me',
                          Text(
                            DateFormat('MMM dd, yyyy').format(_selectedDate),
                            style: Fonts.mindfulMomentTextStyle,
                          ),
                          _showDayPickerDialog,
                        ),
                        Divider(height: screenWidth * 0.01),
                        _buildSettingRow(
                          screenWidth,
                          'On time',
                          Text(
                            _selectedTime.format(context),
                            style: Fonts.mindfulMomentTextStyle,
                          ),
                          _showTimePickerDialog,
                        ),
                        Divider(height: screenWidth * 0.01),
                        _buildSettingRow(
                          screenWidth, 
                          "Repeat",
                          Text(
                            _selectedRepeatType != null
                                ? _selectedRepeatType.name
                                : "None",
                            style: Fonts.mindfulMomentTextStyle,
                          ),
                          _showRepeatTypePickerDialog,
                        ),
                        Divider(height: screenWidth * 0.01),
                        Container(
                            padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.04,
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Reminder is ${_isReminderOn ? 'on' : 'off'}',
                                  style: Fonts.largeTextStyle,
                                ),
                                Switch(
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.deepPurpleAccent,
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
      NotificationService.scheduleNotification(
          AppNotifications.REMINDER.id,
          "Mindful moment",
          "Time to sort up your goals",
          _selectedDate,
          _selectedTime,
          _selectedRepeatType);
    } else {
      NotificationService.cancelNotification(AppNotifications.REMINDER.id);
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
      title: const Text('Repeat type', textAlign: TextAlign.center,),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(RepeatType.DAILY.name, style: Fonts.largeTextStyle),
              trailing: _selectedRepeatType == RepeatType.DAILY
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() {
                  _selectedRepeatType = RepeatType.DAILY;
                });
              },
            ),
            const Divider(),
            ListTile(
              title: Text(RepeatType.WEEKLY.name, style: Fonts.largeTextStyle),
              trailing: _selectedRepeatType == RepeatType.WEEKLY
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() {
                  _selectedRepeatType = RepeatType.WEEKLY;
                });
              },
            ),
            const Divider(),
            ListTile(
              title: Text(RepeatType.BIWEEKLY.name, style: Fonts.largeTextStyle),
              trailing: _selectedRepeatType == RepeatType.BIWEEKLY
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                setState(() {
                  _selectedRepeatType = RepeatType.BIWEEKLY;
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

