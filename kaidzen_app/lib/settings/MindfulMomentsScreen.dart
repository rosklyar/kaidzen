import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/features/FeaturesState.dart';
import 'package:kaidzen_app/service/NotificationService.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/theamedAlertDIalog.dart';

class MindfulMomentsScreen extends StatefulWidget {
  const MindfulMomentsScreen({super.key});

  @override
  _MindfulMomentsScreenState createState() => _MindfulMomentsScreenState();
}

class _MindfulMomentsScreenState extends State<MindfulMomentsScreen> {
  late String _backgroundImage = 'assets/settings/reminder/off.png';
  bool _isReminderOn = false;
  final DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  RepeatType _selectedRepeatType = RepeatType.DAILY;
  WeekDay _selectedWeekDay = WeekDay.MON;

  @override
  _MindfulMomentsScreenState createState() => _MindfulMomentsScreenState();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    var featuresState = Provider.of<FeaturesState>(context, listen: false);
    if (!featuresState.isFeatureDiscovered(Features.REMINDER.id)) {
      featuresState.discoverFeature(Features.REMINDER.id);
    }
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
    await prefs.setString('weekDay', _selectedWeekDay.toString());
    await prefs.setBool('reminderEnabled', _isReminderOn);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final reminderEnabled = prefs.getBool('reminderEnabled');
    if (reminderEnabled != null) {
      bool permissionGranted = await NotificationService.permissionGranted();
      setState(() {
        _isReminderOn = reminderEnabled && permissionGranted;
        _backgroundImage = _isReminderOn
            ? 'assets/settings/reminder/on.png'
            : 'assets/settings/reminder/off.png';
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

    final weekDayString = prefs.getString('weekDay');
    if (weekDayString != null) {
      setState(() {
        _selectedWeekDay = WeekDay.values.firstWhere(
          (e) => e.toString() == weekDayString,
          orElse: () => WeekDay.MON,
        );
      });
    }

    final dateTimeString = prefs.getString('selectedDateTime');
    if (dateTimeString != null) {
      final dateTime = DateTime.parse(dateTimeString);
      setState(() {
        _selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      });
    }
  }

  void _showTimePickerDialog() async {
    final time = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        initialEntryMode: TimePickerEntryMode.input,
        builder: (context, childWidget) => ThemedDialog(context, childWidget));
    if (time != null) {
      setState(() => _selectedTime = time);
      await _savePreferences();
      if (_isReminderOn) {
        await refreshReminderState();
      }
    }
  }

  void _showWeekDayPickerDialog() async {
    final weekDay = await showDialog<WeekDay>(
        context: context,
        builder: (context) => ThemedDialog(
            context, WeekDayPickerDialog(selectedDay: _selectedWeekDay)));
    if (weekDay != null) {
      setState(() => _selectedWeekDay = weekDay);
      await _savePreferences();
      if (_isReminderOn) {
        await refreshReminderState();
      }
    }
  }

  void _showRepeatTypePickerDialog() async {
    final repeatType = await showDialog<RepeatType>(
        context: context,
        builder: (context) => ThemedDialog(context,
            RepeatTypePickerDialog(initialRepeatType: _selectedRepeatType)));
    if (repeatType != null) {
      setState(() => _selectedRepeatType = repeatType);
      await _savePreferences();
      if (_isReminderOn) {
        await refreshReminderState();
      }
    }
  }

  Widget _buildSettingRow(
      double screenWidth, String label, Widget value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.04, horizontal: screenWidth * 0.04),
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
                SvgPicture.asset("assets/edit.svg"),
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
                      '\n\nSet aside regular time for self-reflection and mindfulness to achieve greater results.',
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
                            _selectedRepeatType.name,
                            style: Fonts.mindfulMomentTextStyle,
                          ),
                          _showRepeatTypePickerDialog,
                        ),
                        Visibility(
                          visible: _selectedRepeatType == RepeatType.WEEKLY,
                          child: Column(
                            children: [
                              Divider(height: screenWidth * 0.01),
                              _buildSettingRow(
                                screenWidth,
                                "on ",
                                Text(
                                  _selectedWeekDay.name,
                                  style: Fonts.mindfulMomentTextStyle,
                                ),
                                _showWeekDayPickerDialog,
                              ),
                            ],
                          ),
                        ),
                        Divider(height: screenWidth * 0.01),
                        _buildSettingRow(
                          screenWidth,
                          'at ',
                          Text(
                            _selectedTime.format(context),
                            style: Fonts.mindfulMomentTextStyle,
                          ),
                          _showTimePickerDialog,
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
                                      await requestPermissionPopup(
                                          context, value);
                                    })
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

  Future<void> refreshReminderState() async {
    //cancel existing notification because we could have already set up a daily reminder for tomorrow
    await NotificationService.cancelNotification(AppNotifications.REMINDER.id);
    if (_isReminderOn) {
      await NotificationService.scheduleNotification(
          AppNotifications.REMINDER.id,
          "Mindful moment",
          "Time to sort up your goals",
          _selectedDate,
          _selectedTime,
          _selectedWeekDay,
          _selectedRepeatType);
    }
  }

  Future<void> requestPermissionPopup(BuildContext context, bool value) async {
    PermissionStatus permissionStatus =
        await NotificationService.getPermissionStatus();
    bool initial = permissionStatus == PermissionStatus.unknown;

    if (!value || value && await NotificationService.permissionGranted()) {
      await updateReminderToggle(value);
    } else {
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              textAlign: TextAlign.center,
                              initial
                                  ? "Allow notifications to activate reminder"
                                  : 'Notifications should be enabled in settings',
                              style: Fonts.screenTytleTextStyle)),
                      flex: 6),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              textAlign: TextAlign.center,
                              initial
                                  ? "Next, you'll see a system message asking to allow notifications. We'll take it from there."
                                  : "Next, you'll need to turn on the 'Allow Notifications' option in your phone settings. ",
                              style: Fonts.largeTextStyle)),
                      flex: 5),
                  const Expanded(child: SizedBox(), flex: 1),
                  const Expanded(child: SizedBox(), flex: 1),
                  Expanded(
                      child: GestureDetector(
                          child: Text('Cancel',
                              style: Fonts.largeTextStyle.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                          onTap: () async {
                            Navigator.pop(context);
                          }),
                      flex: 2),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: activeButtonColor),
                              onPressed: () async {
                                Navigator.pop(context);
                                if (permissionStatus !=
                                    PermissionStatus.granted) {
                                  await NotificationPermissions
                                      .requestNotificationPermissions();
                                }
                                if (!value ||
                                    value &&
                                        await NotificationService
                                            .permissionGranted()) {
                                  await updateReminderToggle(value);
                                }
                              },
                              child: Text(
                                  initial ? 'Continue' : 'Open settings',
                                  style: Fonts.largeTextStyle20
                                      .copyWith(color: Colors.white)),
                            )),
                      ),
                      flex: 4),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> updateReminderToggle(bool value) async {
    setState(() {
      _isReminderOn = value;
      _backgroundImage = value
          ? 'assets/settings/reminder/on.png'
          : 'assets/settings/reminder/off.png';
      refreshReminderState();
    });
    await _savePreferences();
  }
}

class WeekDayPickerDialog extends StatefulWidget {
  final WeekDay selectedDay;

  const WeekDayPickerDialog({Key? key, required this.selectedDay})
      : super(key: key);

  @override
  _WeekDayPickerDialogState createState() => _WeekDayPickerDialogState();
}

class _WeekDayPickerDialogState extends State<WeekDayPickerDialog> {
  late WeekDay _selectedDay = WeekDay.MON;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Day of the week',
        textAlign: TextAlign.center,
        style: Fonts.screenTytleTextStyle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              7,
              (index) => ListTile(
                    title: Text(weekDays[index].name,
                        style: _selectedDay.isoId == index + 1
                            ? Fonts.largeBoldTextStyle
                            : Fonts.medium14TextStyle),
                    tileColor: _selectedDay.isoId == index + 1
                        ? AppColors.mindfulMomentsSelection
                        : Colors.white,
                    onTap: () {
                      setState(() {
                        _selectedDay = weekDays[index];
                      });
                    },
                  )),
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
            Navigator.of(context).pop(_selectedDay);
          },
          child: const Text('OK'),
        ),
      ],
    );
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
      title: Text('Repeat type',
          textAlign: TextAlign.center, style: Fonts.screenTytleTextStyle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(RepeatType.DAILY.name,
                  style: _selectedRepeatType == RepeatType.DAILY
                      ? Fonts.largeBoldTextStyle
                      : Fonts.medium14TextStyle),
              tileColor: _selectedRepeatType == RepeatType.DAILY
                  ? AppColors.mindfulMomentsSelection
                  : Colors.white,
              onTap: () {
                setState(() {
                  _selectedRepeatType = RepeatType.DAILY;
                });
              },
            ),
            ListTile(
              title: Text(RepeatType.WEEKLY.name,
                  style: _selectedRepeatType == RepeatType.WEEKLY
                      ? Fonts.largeBoldTextStyle
                      : Fonts.medium14TextStyle),
              tileColor: _selectedRepeatType == RepeatType.WEEKLY
                  ? AppColors.mindfulMomentsSelection
                  : Colors.white,
              onTap: () {
                setState(() {
                  _selectedRepeatType = RepeatType.WEEKLY;
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
