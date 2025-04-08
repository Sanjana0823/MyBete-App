import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_init;
import 'package:shared_preferences/shared_preferences.dart';

class SleepScheduleScreen extends StatefulWidget {
  const SleepScheduleScreen({Key? key}) : super(key: key);

  @override
  State<SleepScheduleScreen> createState() => _SleepScheduleScreenState();
}

class _SleepScheduleScreenState extends State<SleepScheduleScreen> with SingleTickerProviderStateMixin {
  // Default sleep time: 10 PM to 5 AM
  TimeOfDay _bedTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 5, minute: 0);

  // Reminder messages
  String _bedtimeReminderMessage = "Time to sleep! Rest well for tomorrow.";
  String _wakeupReminderMessage = "Good morning! Time to start your day.";

  // Reminder states
  bool _bedtimeReminderEnabled = false;
  bool _wakeupReminderEnabled = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isScheduleActive = false;

  // Notifications
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );

    _animationController.forward();

    // Initialize notifications
    _initializeNotifications();

    // Load saved settings
    _loadSavedSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Initialize notifications
  Future<void> _initializeNotifications() async {
    tz_init.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Load saved settings
  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load bedtime
      final bedtimeHour = prefs.getInt('bedtimeHour') ?? 22;
      final bedtimeMinute = prefs.getInt('bedtimeMinute') ?? 0;
      _bedTime = TimeOfDay(hour: bedtimeHour, minute: bedtimeMinute);

      // Load wake-up time
      final wakeupHour = prefs.getInt('wakeupHour') ?? 5;
      final wakeupMinute = prefs.getInt('wakeupMinute') ?? 0;
      _wakeTime = TimeOfDay(hour: wakeupHour, minute: wakeupMinute);

      // Load schedule state
      _isScheduleActive = prefs.getBool('isScheduleActive') ?? false;

      // Load reminder states
      _bedtimeReminderEnabled = prefs.getBool('bedtimeReminderEnabled') ?? false;
      _wakeupReminderEnabled = prefs.getBool('wakeupReminderEnabled') ?? false;

      // Load reminder messages
      _bedtimeReminderMessage = prefs.getString('bedtimeReminderMessage') ??
          "Time to sleep! Rest well for tomorrow.";
      _wakeupReminderMessage = prefs.getString('wakeupReminderMessage') ??
          "Good morning! Time to start your day.";
    });
  }

  // Save settings
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Save bedtime
    prefs.setInt('bedtimeHour', _bedTime.hour);
    prefs.setInt('bedtimeMinute', _bedTime.minute);

    // Save wake-up time
    prefs.setInt('wakeupHour', _wakeTime.hour);
    prefs.setInt('wakeupMinute', _wakeTime.minute);

    // Save schedule state
    prefs.setBool('isScheduleActive', _isScheduleActive);

    // Save reminder states
    prefs.setBool('bedtimeReminderEnabled', _bedtimeReminderEnabled);
    prefs.setBool('wakeupReminderEnabled', _wakeupReminderEnabled);

    // Save reminder messages
    prefs.setString('bedtimeReminderMessage', _bedtimeReminderMessage);
    prefs.setString('wakeupReminderMessage', _wakeupReminderMessage);
  }

  // Schedule notifications
  Future<void> _scheduleNotifications() async {
    // Cancel existing notifications
    await _flutterLocalNotificationsPlugin.cancelAll();

    if (!_isScheduleActive) {
      return;
    }

    //Schedule bedtime reminder if enabled
    if (_bedtimeReminderEnabled) {
      await _scheduleDailyNotification(
        id: 1,
        title: 'Bedtime Reminder',
        body: _bedtimeReminderMessage,
        hour: _bedTime.hour,
        minute: _bedTime.minute,
      );
    }

    // Schedule wake-up reminder if enabled
    if (_wakeupReminderEnabled) {
      await _scheduleDailyNotification(
        id: 2,
        title: 'Wake-up Reminder',
        body: _wakeupReminderMessage,
        hour: _wakeTime.hour,
        minute: _wakeTime.minute,
      );
    }
  }

  // Schedule a daily notification
  Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'sleep_reminders_channel',
          'Sleep Reminders',
          channelDescription: 'Notifications for sleep and wake-up reminders',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
        iOS: DarwinNotificationDetails(
          sound: 'notification_sound.aiff',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      //uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Calculate sleep duration in hours
  double get _sleepDuration {
    double bedHours = _bedTime.hour + _bedTime.minute / 60.0;
    double wakeHours = _wakeTime.hour + _wakeTime.minute / 60.0;

    // Handle overnight sleep (e.g., 10 PM to 5 AM)
    if (wakeHours < bedHours) {
      return (24 - bedHours) + wakeHours;
    } else {
      return wakeHours - bedHours;
    }
  }

  // Calculate start angle for the arc (in radians)
  double get _startAngle {
    // Convert bed time to a position on the clock (in radians)
    // 12 AM is at the top (270 degrees or -π/2 radians)
    double hourAngle = (_bedTime.hour % 12) / 12 * 2 * math.pi;
    double minuteAngle = _bedTime.minute / 60 * (2 * math.pi / 12);
    double angle = hourAngle + minuteAngle - math.pi / 2;

    // Adjust for PM
    if (_bedTime.hour >= 12) {
      angle += math.pi;
    }

    return angle;
  }

  // Calculate sweep angle for the arc (in radians)
  double get _sweepAngle {
    // Convert sleep duration to radians
    double angle = _sleepDuration / 24 * 2 * math.pi;

    // Ensure we're sweeping in the correct direction
    return angle;
  }

  Future<void> _selectBedTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _bedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF74C7E5),
              onPrimary: Color(0xFF03174C),
              surface: Color(0xFF1A2C65),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _bedTime) {
      setState(() {
        _bedTime = picked;
        _animationController.reset();
        _animationController.forward();
      });

      await _saveSettings();
      if (_isScheduleActive && _bedtimeReminderEnabled) {
        await _scheduleNotifications();
      }
    }
  }

  Future<void> _selectWakeTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF74C7E5),
              onPrimary: Color(0xFF03174C),
              surface: Color(0xFF1A2C65),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _wakeTime) {
      setState(() {
        _wakeTime = picked;
        _animationController.reset();
        _animationController.forward();
      });

      await _saveSettings();
      if (_isScheduleActive && _wakeupReminderEnabled) {
        await _scheduleNotifications();
      }
    }
  }

  Future<void> _toggleSchedule() async {
    setState(() {
      _isScheduleActive = !_isScheduleActive;
    });

    await _saveSettings();

    if (_isScheduleActive) {
      await _scheduleNotifications();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sleep schedule activated'),
          backgroundColor: Color(0xFF03174C),
        ),
      );
    } else {
      await _flutterLocalNotificationsPlugin.cancelAll();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sleep schedule deactivated'),
          backgroundColor: Color(0xFF03174C),
        ),
      );
    }
  }

  // Edit reminder message
  Future<void> _editReminderMessage(bool isBedtime) async {
    final currentMessage = isBedtime ? _bedtimeReminderMessage : _wakeupReminderMessage;
    final controller = TextEditingController(text: currentMessage);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2C65),
        title: Text(
          '${isBedtime ? 'Bedtime' : 'Wake-up'} Reminder Message',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your reminder message',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF74C7E5)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                if (isBedtime) {
                  _bedtimeReminderMessage = controller.text;
                } else {
                  _wakeupReminderMessage = controller.text;
                }
              });

              await _saveSettings();
              if (_isScheduleActive &&
                  ((isBedtime && _bedtimeReminderEnabled) ||
                      (!isBedtime && _wakeupReminderEnabled))) {
                await _scheduleNotifications();
              }

              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFF74C7E5)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03174C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sleep Schedule',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Sleep duration info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.nightlight_round,
                      color: Color(0xFF74C7E5),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_sleepDuration.toStringAsFixed(1)} hours of sleep',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Clock visualization
              SizedBox(
                height: 300,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: ClockPainter(
                        startAngle: _startAngle,
                        sweepAngle: _sweepAngle * _animation.value,
                        bedTime: _bedTime,
                        wakeTime: _wakeTime,
                      ),
                      child: Container(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Time selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTimeSelector(
                        label: 'Bedtime',
                        time: _bedTime,
                        icon: Icons.bedtime_outlined,
                        onTap: _selectBedTime,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimeSelector(
                        label: 'Wake up',
                        time: _wakeTime,
                        icon: Icons.wb_sunny_outlined,
                        onTap: _selectWakeTime,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Bedtime reminder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  color: const Color(0xFF1A2C65),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              color: Color(0xFF74C7E5),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Bedtime Reminder',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                              value: _bedtimeReminderEnabled,
                              onChanged: (value) async {
                                setState(() {
                                  _bedtimeReminderEnabled = value;
                                });
                                await _saveSettings();
                                if (_isScheduleActive) {
                                  await _scheduleNotifications();
                                }
                              },
                              activeColor: const Color(0xFF74C7E5),
                              activeTrackColor: const Color(0xFF74C7E5).withOpacity(0.5),
                            ),
                          ],
                        ),
                        if (_bedtimeReminderEnabled) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF03174C),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _bedtimeReminderMessage,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF74C7E5),
                                ),
                                onPressed: () => _editReminderMessage(true),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Wake-up reminder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  color: const Color(0xFF1A2C65),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              color: Color(0xFFF5C371),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Wake-up Reminder',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                              value: _wakeupReminderEnabled,
                              onChanged: (value) async {
                                setState(() {
                                  _wakeupReminderEnabled = value;
                                });
                                await _saveSettings();
                                if (_isScheduleActive) {
                                  await _scheduleNotifications();
                                }
                              },
                              activeColor: const Color(0xFFF5C371),
                              activeTrackColor: const Color(0xFFF5C371).withOpacity(0.5),
                            ),
                          ],
                        ),
                        if (_wakeupReminderEnabled) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF03174C),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _wakeupReminderMessage,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFF5C371),
                                ),
                                onPressed: () => _editReminderMessage(false),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Activate button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: _toggleSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isScheduleActive
                        ? const Color(0xFF74C7E5)
                        : const Color(0xFF0048FF),
                    foregroundColor: _isScheduleActive
                        ? const Color(0xFF03174C)
                        : Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    _isScheduleActive ? 'Deactivate Schedule' : 'Activate Schedule',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2C65),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFADB9D1),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF74C7E5),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTimeOfDay(time),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final double startAngle;
  final double sweepAngle;
  final TimeOfDay bedTime;
  final TimeOfDay wakeTime;

  ClockPainter({
    required this.startAngle,
    required this.sweepAngle,
    required this.bedTime,
    required this.wakeTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.4;

    // Draw clock face
    final clockPaint = Paint()
      ..color = const Color(0xFF1A2C65)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, clockPaint);

    // Draw clock border
    final borderPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, borderPaint);

    // Draw hour markers
    final markerPaint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final angle = i * (2 * math.pi / 12) - math.pi / 2;
      final markerRadius = i % 3 == 0 ? 6.0 : 3.0;

      final markerCenter = Offset(
        center.dx + (radius - 15) * math.cos(angle),
        center.dy + (radius - 15) * math.sin(angle),
      );

      canvas.drawCircle(markerCenter, markerRadius, markerPaint);

      // Draw hour numbers
      if (i % 3 == 0) {
        final hour = i == 0 ? '12' : (i).toString();
        final textPainter = TextPainter(
          text: TextSpan(
            text: hour,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        final textCenter = Offset(
          center.dx + (radius - 40) * math.cos(angle) - textPainter.width / 2,
          center.dy + (radius - 40) * math.sin(angle) - textPainter.height / 2,
        );

        textPainter.paint(canvas, textCenter);
      }
    }

    // Draw AM/PM indicators
    final amPmTextPainter = TextPainter(
      text: const TextSpan(
        text: 'AM',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    amPmTextPainter.layout();
    amPmTextPainter.paint(
      canvas,
      Offset(center.dx - amPmTextPainter.width / 2, center.dy - radius / 2),
    );

    final pmTextPainter = TextPainter(
      text: const TextSpan(
        text: 'PM',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    pmTextPainter.layout();
    pmTextPainter.paint(
      canvas,
      Offset(center.dx - pmTextPainter.width / 2, center.dy + radius / 3),
    );

    // Draw sleep arc
    final sleepPaint = Paint()
      ..color = const Color(0xFF74C7E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 25),
      startAngle,
      sweepAngle,
      false,
      sleepPaint,
    );

    // Draw bedtime indicator
    final bedTimePaint = Paint()
      ..color = const Color(0xFFF5C371)
      ..style = PaintingStyle.fill;

    final bedTimeCenter = Offset(
      center.dx + (radius - 25) * math.cos(startAngle),
      center.dy + (radius - 25) * math.sin(startAngle),
    );

    canvas.drawCircle(bedTimeCenter, 10, bedTimePaint);

    // Draw wake time indicator
    final wakeTimePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final wakeTimeCenter = Offset(
      center.dx + (radius - 25) * math.cos(startAngle + sweepAngle),
      center.dy + (radius - 25) * math.sin(startAngle + sweepAngle),
    );

    canvas.drawCircle(wakeTimeCenter, 10, wakeTimePaint);

    // Draw moon icon in center
    final moonPaint = Paint()
      ..color = const Color(0xFFF5C371)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 30, moonPaint);

    // Draw crescent
    final crescentPaint = Paint()
      ..color = const Color(0xFF03174C)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx + 10, center.dy - 5),
      25,
      crescentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    return oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.bedTime != bedTime ||
        oldDelegate.wakeTime !=wakeTime;
    }
}
