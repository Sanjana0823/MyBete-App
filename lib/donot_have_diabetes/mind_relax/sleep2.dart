import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_init;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/sleep_dashboard.dart';

// Firebase service for sleep data
class SleepService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get userId => _auth.currentUser?.uid;

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // Get user sleep data reference
  DocumentReference get userSleepDoc => _firestore
      .collection('users')
      .doc(userId)
      .collection('sleep')
      .doc('schedule');

  // Save sleep schedule to Firebase
  Future<void> saveSleepSchedule({
    required TimeOfDay bedTime,
    required TimeOfDay wakeTime,
    required bool isScheduleActive,
    required bool bedtimeReminderEnabled,
    required bool wakeupReminderEnabled,
    required String bedtimeReminderMessage,
    required String wakeupReminderMessage,
  }) async {
    if (!isLoggedIn) return;

    await userSleepDoc.set({
      'bedtimeHour': bedTime.hour,
      'bedtimeMinute': bedTime.minute,
      'wakeupHour': wakeTime.hour,
      'wakeupMinute': wakeTime.minute,
      'isScheduleActive': isScheduleActive,
      'bedtimeReminderEnabled': bedtimeReminderEnabled,
      'wakeupReminderEnabled': wakeupReminderEnabled,
      'bedtimeReminderMessage': bedtimeReminderMessage,
      'wakeupReminderMessage': wakeupReminderMessage,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Load sleep schedule from Firebase
  Future<Map<String, dynamic>?> loadSleepSchedule() async {
    if (!isLoggedIn) return null;

    final doc = await userSleepDoc.get();
    return doc.exists ? doc.data() as Map<String, dynamic> : null;
  }

  // Save sleep history
  Future<void> logSleepSession({
    required DateTime bedTime,
    required DateTime wakeTime,
    required double sleepDuration,
    required double sleepQuality,
  }) async {
    if (!isLoggedIn) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('sleepHistory')
        .add({
      'bedTime': bedTime,
      'wakeTime': wakeTime,
      'sleepDuration': sleepDuration,
      'sleepQuality': sleepQuality,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get sleep history
  Future<List<Map<String, dynamic>>> getSleepHistory({int limit = 7}) async {
    if (!isLoggedIn) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('sleepHistory')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Sign in anonymously for testing
  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }
}

// Sleep timer service
class SleepTimer {
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // Available sounds
  final List<String> sounds = [
    'rain',
    'white_noise',
    'ocean',
    'forest',
    'meditation'
  ];

  // Current sound
  String _currentSound = 'rain';
  int _remainingMinutes = 30;

  // Callbacks
  Function()? onTimerComplete;
  Function(int)? onTimerTick;

  // Start sleep timer with sound
  Future<void> startTimer(String sound, int minutes) async {
    // Stop any existing timer
    stopTimer();

    _currentSound = sound;
    _remainingMinutes = minutes;

    // Start playing the selected sound
    await _audioPlayer.play(AssetSource('sounds/$sound.mp3'));
    _isPlaying = true;

    // Start the countdown timer
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _remainingMinutes--;

      // Notify listeners about the tick
      if (onTimerTick != null) {
        onTimerTick!(_remainingMinutes);
      }

      // Check if timer is complete
      if (_remainingMinutes <= 0) {
        stopTimer();
        if (onTimerComplete != null) {
          onTimerComplete!();
        }
      }
    });
  }

  // Stop the timer and sound
  void stopTimer() {
    _timer?.cancel();
    _timer = null;

    if (_isPlaying) {
      _audioPlayer.stop();
      _isPlaying = false;
    }
  }

  // Pause/resume the sound
  void toggleSound() {
    if (_isPlaying) {
      _audioPlayer.pause();
      _isPlaying = false;
    } else {
      _audioPlayer.resume();
      _isPlaying = true;
    }
  }

  // Change volume
  void setVolume(double volume) {
    _audioPlayer.setVolume(volume);
  }

  // Get remaining time
  int get remainingMinutes => _remainingMinutes;

  // Check if timer is active
  bool get isActive => _timer != null;

  // Check if sound is playing
  bool get isPlaying => _isPlaying;

  // Get current sound
  String get currentSound => _currentSound;

  // Dispose resources
  void dispose() {
    stopTimer();
    _audioPlayer.dispose();
  }
}

// Enhanced notification service
class SleepNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initialize() async {
    tz_init.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  // Request notification permissions
  Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();

    return granted ?? false;
  }

  // Schedule a daily notification
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? sound,
    String? payload,
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

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'sleep_reminders_channel',
          'Sleep Reminders',
          channelDescription: 'Notifications for sleep and wake-up reminders',
          importance: Importance.high,
          priority: Priority.high,
          sound:
              sound != null ? RawResourceAndroidNotificationSound(sound) : null,
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
        iOS: DarwinNotificationDetails(
          sound: sound != null ? '$sound.aiff' : null,
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  // Schedule a one-time notification
  Future<void> scheduleOnceNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? sound,
    String? payload,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'sleep_reminders_channel',
          'Sleep Reminders',
          channelDescription: 'Notifications for sleep and wake-up reminders',
          importance: Importance.high,
          priority: Priority.high,
          sound:
              sound != null ? RawResourceAndroidNotificationSound(sound) : null,
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
        iOS: DarwinNotificationDetails(
          sound: sound != null ? '$sound.aiff' : null,
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  // Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'sleep_reminders_channel',
          'Sleep Reminders',
          channelDescription: 'Notifications for sleep and wake-up reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}

extension on AndroidFlutterLocalNotificationsPlugin? {
  requestPermissions() {}
}

// Main Sleep Schedule Screen
class SleepScheduleScreen extends StatefulWidget {
  const SleepScheduleScreen({Key? key}) : super(key: key);

  @override
  State<SleepScheduleScreen> createState() => _SleepScheduleScreenState();
}

class _SleepScheduleScreenState extends State<SleepScheduleScreen>
    with SingleTickerProviderStateMixin {
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
  bool _isLoading = true;
  bool _isSyncing = false;

  // Sleep timer state
  bool _isTimerActive = false;
  int _timerDuration = 30;
  String _selectedSound = 'rain';
  double _volume = 0.5;

  // Services
  final SleepService _sleepService = SleepService();
  final SleepTimer _sleepTimer = SleepTimer();
  final SleepNotificationService _notificationService =
      SleepNotificationService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();

    // Initialize services
    _initializeApp();

    // Set up timer callbacks
    _sleepTimer.onTimerComplete = _onTimerComplete;
    _sleepTimer.onTimerTick = _onTimerTick;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sleepTimer.dispose();
    super.dispose();
  }

  // Initialize app
  Future<void> _initializeApp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize Firebase
      await Firebase.initializeApp();

      // Initialize notifications
      await _notificationService.initialize();
      await _notificationService.requestPermissions();

      // Sign in anonymously for testing
      if (!_sleepService.isLoggedIn) {
        await _sleepService.signInAnonymously();
      }

      // Try to load from Firebase first
      final firebaseData = await _sleepService.loadSleepSchedule();

      if (firebaseData != null) {
        _loadFromFirebase(firebaseData);
      } else {
        // Fall back to local storage
        await _loadFromLocalStorage();
      }
    } catch (e) {
      // If Firebase fails, load from local storage
      await _loadFromLocalStorage();
    } finally {
      setState(() {
        _isLoading = false;
      });

      // Schedule notifications if active
      if (_isScheduleActive) {
        await _scheduleNotifications();
      }
    }
  }

  // Load data from Firebase
  void _loadFromFirebase(Map<String, dynamic> data) {
    setState(() {
      // Load bedtime
      final bedtimeHour = data['bedtimeHour'] ?? 22;
      final bedtimeMinute = data['bedtimeMinute'] ?? 0;
      _bedTime = TimeOfDay(hour: bedtimeHour, minute: bedtimeMinute);

      // Load wake-up time
      final wakeupHour = data['wakeupHour'] ?? 5;
      final wakeupMinute = data['wakeupMinute'] ?? 0;
      _wakeTime = TimeOfDay(hour: wakeupHour, minute: wakeupMinute);

      // Load schedule state
      _isScheduleActive = data['isScheduleActive'] ?? false;

      // Load reminder states
      _bedtimeReminderEnabled = data['bedtimeReminderEnabled'] ?? false;
      _wakeupReminderEnabled = data['wakeupReminderEnabled'] ?? false;

      // Load reminder messages
      _bedtimeReminderMessage = data['bedtimeReminderMessage'] ??
          "Time to sleep! Rest well for tomorrow.";
      _wakeupReminderMessage = data['wakeupReminderMessage'] ??
          "Good morning! Time to start your day.";
    });
  }

  // Load from local storage
  Future<void> _loadFromLocalStorage() async {
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
      _bedtimeReminderEnabled =
          prefs.getBool('bedtimeReminderEnabled') ?? false;
      _wakeupReminderEnabled = prefs.getBool('wakeupReminderEnabled') ?? false;

      // Load reminder messages
      _bedtimeReminderMessage = prefs.getString('bedtimeReminderMessage') ??
          "Time to sleep! Rest well for tomorrow.";
      _wakeupReminderMessage = prefs.getString('wakeupReminderMessage') ??
          "Good morning! Time to start your day.";
    });
  }

  // Save settings to both Firebase and local storage
  Future<void> _saveSettings() async {
    setState(() {
      _isSyncing = true;
    });

    try {
      // Save to Firebase
      await _sleepService.saveSleepSchedule(
        bedTime: _bedTime,
        wakeTime: _wakeTime,
        isScheduleActive: _isScheduleActive,
        bedtimeReminderEnabled: _bedtimeReminderEnabled,
        wakeupReminderEnabled: _wakeupReminderEnabled,
        bedtimeReminderMessage: _bedtimeReminderMessage,
        wakeupReminderMessage: _wakeupReminderMessage,
      );

      // Save to local storage as backup
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
    } finally {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  // Schedule notifications
  Future<void> _scheduleNotifications() async {
    // Cancel existing notifications
    await _notificationService.cancelAllNotifications();

    if (!_isScheduleActive) {
      return;
    }

    // Schedule bedtime reminder if enabled
    if (_bedtimeReminderEnabled) {
      await _notificationService.scheduleDailyNotification(
        id: 1,
        title: 'Bedtime Reminder',
        body: _bedtimeReminderMessage,
        hour: _bedTime.hour,
        minute: _bedTime.minute,
        sound: 'notification_sound',
      );
    }

    // Schedule wake-up reminder if enabled
    if (_wakeupReminderEnabled) {
      await _notificationService.scheduleDailyNotification(
        id: 2,
        title: 'Wake-up Reminder',
        body: _wakeupReminderMessage,
        hour: _wakeTime.hour,
        minute: _wakeTime.minute,
        sound: 'alarm_sound',
      );
    }
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
      await _notificationService.cancelAllNotifications();
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
    final currentMessage =
        isBedtime ? _bedtimeReminderMessage : _wakeupReminderMessage;
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

  // Show sleep timer dialog
  Future<void> _showSleepTimerDialog() async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1A2C65),
            title: const Text(
              'Sleep Timer',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Timer duration slider
                const Text(
                  'Timer Duration',
                  style: TextStyle(color: Colors.white70),
                ),
                Slider(
                  value: _timerDuration.toDouble(),
                  min: 5,
                  max: 120,
                  divisions: 23,
                  label: '$_timerDuration minutes',
                  activeColor: const Color(0xFF74C7E5),
                  onChanged: (value) {
                    setDialogState(() {
                      _timerDuration = value.round();
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Sound selection
                const Text(
                  'Sound',
                  style: TextStyle(color: Colors.white70),
                ),
                DropdownButton<String>(
                  value: _selectedSound,
                  dropdownColor: const Color(0xFF03174C),
                  style: const TextStyle(color: Colors.white),
                  underline: Container(
                    height: 1,
                    color: const Color(0xFF74C7E5),
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setDialogState(() {
                        _selectedSound = newValue;
                      });
                    }
                  },
                  items: _sleepTimer.sounds
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Volume slider
                const Text(
                  'Volume',
                  style: TextStyle(color: Colors.white70),
                ),
                Slider(
                  value: _volume,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  activeColor: const Color(0xFF74C7E5),
                  onChanged: (value) {
                    setDialogState(() {
                      _volume = value;
                    });
                    if (_sleepTimer.isPlaying) {
                      _sleepTimer.setVolume(_volume);
                    }
                  },
                ),
              ],
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
                onPressed: () {
                  if (_sleepTimer.isActive) {
                    _sleepTimer.stopTimer();
                    setState(() {
                      _isTimerActive = false;
                    });
                  } else {
                    _sleepTimer.startTimer(_selectedSound, _timerDuration);
                    setState(() {
                      _isTimerActive = true;
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  _sleepTimer.isActive ? 'Stop Timer' : 'Start Timer',
                  style: const TextStyle(color: Color(0xFF74C7E5)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Timer complete callback
  void _onTimerComplete() {
    setState(() {
      _isTimerActive = false;
    });

    // Show notification
    _notificationService.showNotification(
      id: 3,
      title: 'Sleep Timer',
      body: 'Your sleep timer has ended',
    );
  }

  // Timer tick callback
  void _onTimerTick(int remainingMinutes) {
    // Update UI if needed
    setState(() {
      // This will trigger a rebuild if the screen is visible
    });
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            if (_isSyncing)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.timer, color: Colors.white),
              onPressed: _showSleepTimerDialog,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF74C7E5),
                ),
              )
            : SafeArea(
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

                      // Sleep timer indicator (if active)
                      if (_isTimerActive) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A2C65),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Color(0xFF74C7E5),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sleep timer: ${_sleepTimer.remainingMinutes} min',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  _sleepTimer.toggleSound();
                                  setState(() {});
                                },
                                child: Icon(
                                  _sleepTimer.isPlaying
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: const Color(0xFF74C7E5),
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

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
                                      activeTrackColor: const Color(0xFF74C7E5)
                                          .withOpacity(0.5),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                        onPressed: () =>
                                            _editReminderMessage(true),
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
                                      activeTrackColor: const Color(0xFFF5C371)
                                          .withOpacity(0.5),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                        onPressed: () =>
                                            _editReminderMessage(false),
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
                            _isScheduleActive
                                ? 'Deactivate Schedule'
                                : 'Activate Schedule',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Back button at the bottom
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back to Sleep Timer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A2C65),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
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
        oldDelegate.wakeTime != wakeTime;
  }
}
