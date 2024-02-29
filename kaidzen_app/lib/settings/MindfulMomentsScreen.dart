import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/assets/light_dark_theme.dart';
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
  late String _backgroundImage = 'assets/settings/reminder/off_dark.png';
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
            ? 'assets/settings/reminder/on_dark.png'
            : 'assets/settings/reminder/off_dark.png';
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
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: dark_light_modes.mindfulMomentsSelectionPicker(
                  isDarkTheme), // header background color
              // onPrimary: Colors.white, // header text color
              surface: dark_light_modes.ScreenBackColor(
                  isDarkTheme), // dial background color
              onSurface: dark_light_modes.statusIcon(isDarkTheme),

              // dial text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                // Text color for the buttons
                primary: (isDarkTheme ? Colors.grey[100] : Colors.deepPurple),
                // Background color can be set here, though typically not used for text buttons
                backgroundColor: dark_light_modes.ScreenBackColor(isDarkTheme),
              ),
            ),
            dialogBackgroundColor: dark_light_modes.ScreenBackColor(
                isDarkTheme), // Background color
          ),
          child: child!,
        );
      },
    );
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
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;

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
              style: Fonts_mode.largeTextStyle(isDarkTheme),
            ),
            Row(
              children: [
                value,
                SizedBox(width: screenWidth * 0.04),
                Icon(Icons.edit,
                    color: dark_light_modes.statusIcon(isDarkTheme)),
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
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: dark_light_modes.ScreenBackColor(isDarkTheme),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: dark_light_modes.statusIcon(isDarkTheme),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0,
          title: Text('Mindful moments',
              style: Fonts_mode.screenTytleTextStyle(isDarkTheme)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: dark_light_modes.statusIcon(isDarkTheme),
              ),
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
              flex: 5,
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
                      style: Fonts_mode.largeTextStyle(isDarkTheme),
                    ),
                    SizedBox(height: screenWidth * 0.05),
                    Text(
                      'Use this time for planning your life, establishing meaningful goals, and focusing on the ones that matter the most.',
                      style: Fonts_mode.largeTextStyle(isDarkTheme),
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
                            style:
                                Fonts_mode.mindfulMomentTextStyle(isDarkTheme),
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
                                  style: Fonts_mode.mindfulMomentTextStyle(
                                      isDarkTheme),
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
                            style:
                                Fonts_mode.mindfulMomentTextStyle(isDarkTheme),
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
                                  style: Fonts_mode.largeTextStyle(isDarkTheme),
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

    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;

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
                              style: Fonts_mode.screenTytleTextStyle(
                                  isDarkTheme))),
                      flex: 6),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              textAlign: TextAlign.center,
                              initial
                                  ? "Next, you'll see a system message asking to allow notifications. We'll take it from there."
                                  : "Next, you'll need to turn on the 'Allow Notifications' option in your phone settings. ",
                              style: Fonts_mode.largeTextStyle(isDarkTheme))),
                      flex: 5),
                  const Expanded(child: SizedBox(), flex: 1),
                  const Expanded(child: SizedBox(), flex: 1),
                  Expanded(
                      child: GestureDetector(
                          child: Text('Cancel',
                              style: Fonts_mode.largeTextStyle(isDarkTheme)
                                  .copyWith(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              )),
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
                                  style:
                                      Fonts_mode.largeTextStyle20(isDarkTheme)
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
          ? 'assets/settings/reminder/on_dark.png'
          : 'assets/settings/reminder/off_dark.png';
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
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;
    return AlertDialog(
      backgroundColor: dark_light_modes.ScreenBackColor(isDarkTheme),
      title: Text(
        'Day of the week',
        textAlign: TextAlign.center,
        style: Fonts_mode.screenTytleTextStyle(isDarkTheme),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              7,
              (index) => ListTile(
                    title: Text(weekDays[index].name,
                        style: _selectedDay.isoId == index + 1
                            ? Fonts_mode.largeBoldTextStyle(isDarkTheme)
                            : Fonts_mode.medium14TextStyle(isDarkTheme)),
                    tileColor: _selectedDay.isoId == index + 1
                        ? dark_light_modes.mindfulMomentsSelection(isDarkTheme)
                        : dark_light_modes.unselectedToggleColor(isDarkTheme),
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
            child: Text('CANCEL',
                style: Fonts_mode.mindfulMomentTextStyleLarge(isDarkTheme,
                    fontWeight: FontWeight.w500, fontSize: 16))),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedDay);
          },
          child: Text('OK',
              style: Fonts_mode.mindfulMomentTextStyleLarge(isDarkTheme,
                  fontWeight: FontWeight.w500, fontSize: 16)),
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
    final themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    bool isDarkTheme = themeProvider.darkTheme;
    return AlertDialog(
      backgroundColor: dark_light_modes.ScreenBackColor(isDarkTheme),
      title: Text('Repeat type',
          textAlign: TextAlign.center,
          style: Fonts_mode.screenTytleTextStyle(isDarkTheme)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(RepeatType.DAILY.name,
                  style: _selectedRepeatType == RepeatType.DAILY
                      ? Fonts_mode.largeBoldTextStyle(isDarkTheme)
                      : Fonts_mode.medium14TextStyle(isDarkTheme)),
              tileColor: _selectedRepeatType == RepeatType.DAILY
                  ? dark_light_modes.mindfulMomentsSelection(isDarkTheme)
                  : dark_light_modes.unselectedToggleColor(isDarkTheme),
              onTap: () {
                setState(() {
                  _selectedRepeatType = RepeatType.DAILY;
                });
              },
            ),
            ListTile(
              title: Text(RepeatType.WEEKLY.name,
                  style: _selectedRepeatType == RepeatType.WEEKLY
                      ? Fonts_mode.largeBoldTextStyle(isDarkTheme)
                      : Fonts_mode.medium14TextStyle(isDarkTheme)),
              tileColor: _selectedRepeatType == RepeatType.WEEKLY
                  ? dark_light_modes.mindfulMomentsSelection(isDarkTheme)
                  : dark_light_modes.unselectedToggleColor(isDarkTheme),
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
          child: Text('CANCEL',
              style: Fonts_mode.mindfulMomentTextStyleLarge(isDarkTheme,
                  fontWeight: FontWeight.w500, fontSize: 16)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedRepeatType);
          },
          child: Text('OK',
              style: Fonts_mode.mindfulMomentTextStyleLarge(isDarkTheme,
                  fontWeight: FontWeight.w500, fontSize: 16)),
        ),
      ],
    );
  }
}
