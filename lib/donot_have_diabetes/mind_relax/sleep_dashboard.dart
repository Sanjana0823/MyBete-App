import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/sleep2.dart';

void main() {
  runApp(SleepApp());
}

class SleepApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Stories',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      home: SleepDashboard(),
    );
  }
}

class SleepDashboard extends StatefulWidget {
  @override
  _SleepDashboardState createState() => _SleepDashboardState();
}

class _SleepDashboardState extends State<SleepDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    SleepStoriesPage(),
    SleepMusicPage(),
    SleepTimerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F1123),
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Stories'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
        ],
      ),
    );
  }
}

class SleepStoriesPage extends StatelessWidget {
  final List<String> stories = [
    'The Whispering Forest',
    'The Starboat Voyage',
    'Cloud Cat’s Nap',
    'The Lantern of Dreams',
    'The Mountain That Sleeps',
    'Beneath the Blanket Tree',
  ];

  final Map<String, String> storyContents = {
    'The Whispering Forest': '''
In a forest where the trees hum lullabies and the leaves murmur secrets of old...
''',
    'The Starboat Voyage': '''
Each night, when the sky turns deep indigo, Captain Luna and her owl crew sail...
''',
    'Cloud Cat’s Nap': '''
Way up high, above the tallest skies, lives a soft, fluffy cat named Nimbus...
''',
    'The Lantern of Dreams': '''
In a small village where dreams grow like flowers, a quiet girl named Elira...
''',
    'The Mountain That Sleeps': '''
There’s a mountain so old and still, it’s said to be asleep. The wind tiptoes...
''',
    'Beneath the Blanket Tree': '''
In the heart of a meadow stands the Blanket Tree — its branches heavy with quilts...
''',
  };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final storyTitle = stories[index];
        return Card(
          color: const Color(0xFF2C2C54),
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            title: Text(
              storyTitle,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            subtitle: const Text('Tap to listen',
                style: TextStyle(color: Colors.white60)),
            leading:
                const Icon(Icons.nightlight_round, color: Colors.tealAccent),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1A2E),
                  title: Text(
                    storyTitle,
                    style: const TextStyle(color: Colors.tealAccent),
                  ),
                  content: SingleChildScrollView(
                    child: Text(
                      storyContents[storyTitle] ?? 'Story not found.',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Close',
                          style: TextStyle(color: Colors.tealAccent)),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class SleepMusicPage extends StatefulWidget {
  @override
  _SleepMusicPageState createState() => _SleepMusicPageState();
}

class _SleepMusicPageState extends State<SleepMusicPage> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentTrack;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'Dreamy Tranquility',
      'path':
          'lib/donot_have_diabetes/mind_relax/audio/sleep/dreamy-tranquilitysoothing-528-hz-theta-sound-waves.mp3',
    },
    {
      'title': 'Very Deep Sleep',
      'path':
          'lib/donot_have_diabetes/mind_relax/audio/sleep/very-deep-sleep-music-meditation.mp3',
    },
    {
      'title': 'Eternal Hush',
      'path':
          'lib/donot_have_diabetes/mind_relax/audio/sleepeternal-hush-for-deep-sleep.mp3',
    },
  ];

  void _playAudio(String path, String title) async {
    if (_currentTrack == path) {
      await _player.stop();
      setState(() => _currentTrack = null);
    } else {
      await _player.stop();
      await _player.play(AssetSource(path));
      setState(() => _currentTrack = path);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tracks.length,
      itemBuilder: (context, index) {
        final track = _tracks[index];
        final isPlaying = _currentTrack == track['path'];

        return Card(
          color: const Color(0xFF2C2C54),
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.tealAccent,
              size: 32,
            ),
            title: Text(
              track['title']!,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () => _playAudio(track['path']!, track['title']!),
          ),
        );
      },
    );
  }
}

class SleepTimerPage extends StatefulWidget {
  @override
  _SleepTimerPageState createState() => _SleepTimerPageState();
}

class _SleepTimerPageState extends State<SleepTimerPage> {
  Duration _duration = const Duration(minutes: 10);

  void _startTimer() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('')),
    );

    // Navigate to sleep2.dart (Sleep2Page) immediately
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SleepScheduleScreen()),
    );

    // TODO: You can add a delayed sleep stop logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Set Sleep Timer',
              style: TextStyle(fontSize: 24, color: Colors.white)),
          const SizedBox(height: 20),
          Slider(
            min: 5,
            max: 60,
            divisions: 11,
            label: '${_duration.inMinutes} min',
            value: _duration.inMinutes.toDouble(),
            onChanged: (value) {
              setState(() => _duration = Duration(minutes: value.toInt()));
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _startTimer,
            icon: const Icon(Icons.timer),
            label: const Text('Start Timer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
