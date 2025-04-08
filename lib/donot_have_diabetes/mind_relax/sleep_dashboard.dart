import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mybete_app/donot_have_diabetes/mind_relax/sleep2.dart';
import 'dart:async';

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
  final List<Map<String, String>> stories = [
    {
      'title': 'The Whispering Forest',
      'content': '''
In a forest where the trees hum lullabies and the leaves murmur secrets of old, there lived a small fox named Ember. 
Every night, Ember would curl up beneath the oldest oak tree, whose branches swayed gently, creating a soothing rhythm.
The stars above twinkled through the canopy, casting a soft, silver glow on the forest floor.
As Ember's eyes grew heavy, the forest whispered its ancient stories, tales of peaceful nights and sweet dreams.
The gentle rustling of leaves became a lullaby, and Ember drifted into a deep, restful sleep.
''',
    },
    {
      'title': 'The Starboat Voyage',
      'content': '''
Each night, when the sky turns deep indigo, Captain Luna and her owl crew sail their starboat across the night sky.
The boat, made of moonbeams and stardust, glides silently above sleeping towns and quiet forests.
Captain Luna steers with a compass that points toward dreams, while her crew collects wishes that float up from below.
The gentle rocking of the starboat soothes all who glimpse it from their windows, their eyelids growing heavy with each sway.
By morning, the starboat docks behind the sun, ready for another journey when twilight returns.
''',
    },
    {
      'title': 'Cloud Cat\'s Nap',
      'content': '''
Way up high, above the tallest skies, lives a soft, fluffy cat named Nimbus who is made entirely of clouds.
Nimbus spends his days stretching across the blue expanse, changing shapes and watching the world below.
When evening comes, Nimbus curls into a perfect cloud-ball, his purrs creating the gentle rumble of distant thunder.
Rain falls softly when he kneads his cloud paws in contentment, a light sprinkle that helps flowers dream.
Those who listen closely on quiet nights can hear his cloud-soft breathing, a rhythm that lulls even the most restless to sleep.
''',
    },
    {
      'title': 'The Lantern of Dreams',
      'content': '''
In a small village where dreams grow like flowers, a quiet girl named Elira tends to a special lantern.
Each evening, she walks through the village, lighting her lantern with a flame that glows in all colors at once.
The light from her lantern seeps through windows and under doors, touching the eyelids of everyone it reaches.
When the lantern's light finds you, your mind fills with beautiful visions and peaceful journeys.
Elira walks until every home is touched by her light, before returning to her cottage to sleep beneath her own lantern's glow.
''',
    },
    {
      'title': 'The Mountain That Sleeps',
      'content': '''
There's a mountain so old and still, it's said to be asleep. The wind tiptoes around its peaks, and clouds form a blanket across its shoulders.
Animals who make their homes on the mountain move quietly, respecting the mountain's deep slumber.
The mountain dreams of the ages it has seen, of dinosaurs and ice ages, of the first humans and ancient civilizations.
Its dreams are so powerful that anyone who rests upon its slopes falls into the deepest, most restful sleep.
The mountain's gentle snores can be heard as the distant echo that rolls through valleys on still nights.
''',
    },
    {
      'title': 'Beneath the Blanket Tree',
      'content': '''
In the heart of a meadow stands the Blanket Tree — its branches heavy with quilts and comforters instead of leaves.
Children from the nearby village visit the tree when they can't sleep, to select the perfect blanket for dreaming.
Each blanket has its own magic: some bring dreams of flying, others of swimming with gentle sea creatures.
The Blanket Tree grows from seeds of yawns and stretches, watered by the quiet moments before sleep.
When wrapped in one of its blankets, even the most awake eyes grow heavy, and minds drift into peaceful slumber.
''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Stories', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F1123),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Card(
            color: const Color(0xFF2C2C54),
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(
                story['title']!,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              subtitle: const Text('Tap to read',
                  style: TextStyle(color: Colors.white60)),
              leading: const Icon(Icons.nightlight_round, color: Colors.tealAccent),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDetailPage(
                      title: story['title']!,
                      content: story['content']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class StoryDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const StoryDetailPage({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F1123),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Stories'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SleepMusicPage extends StatefulWidget {
  @override
  _SleepMusicPageState createState() => _SleepMusicPageState();
}

class _SleepMusicPageState extends State<SleepMusicPage> with AutomaticKeepAliveClientMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentTrackPath;
  double _volume = 0.5;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Fixed track paths - make sure these match your actual asset paths
  final List<Map<String, String>> _tracks = [
    {
      'title': 'sleep clam',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/sleep/sleep-music-vol15.mp3',
    },
    {
      'title': 'sleep Vibes',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/sleep/sleep-music-vol16.mp3',
    },
    {
      'title': 'sleep',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/sleep/eternal-hush-for-deep-sleep.mp3',
    },
    {
      'title': 'Deep Space Humming',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/sleep/dreamy-tranquilitysoothing-528-hz-theta-sound-waves.mp3',
    },
    
    {
      'title': 'sleep Music',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/sleep/deep-sleep.mp3',
    },
    {
      'title': 'sleep Stomp',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/sleep/very-deep-sleep-music-meditation.mp3',
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    // Listen to audio player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    // Set initial volume
    _audioPlayer.setVolume(_volume);
    
    // Listen for completion
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  Future<void> _playAudio(String path) async {
    try {
      if (_currentTrackPath == path && _isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else if (_currentTrackPath == path && !_isPlaying) {
        await _audioPlayer.resume();
        setState(() {
          _isPlaying = true;
        });
      } else {
        // Stop current track if any
        if (_isPlaying) {
          await _audioPlayer.stop();
        }
        
        // Play new track
        // Debug print to check path
        print('Attempting to play: $path');
        
        // Reset position
        setState(() {
          _position = Duration.zero;
        });
        
        // Use Source.asset for assets in the assets folder
        await _audioPlayer.play(AssetSource(path));
        
        setState(() {
          _currentTrackPath = path;
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error playing audio: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Music', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F1123),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Music player controls
          if (_currentTrackPath != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF16213E),
              child: Column(
                children: [
                  Text(
                    _tracks.firstWhere((track) => track['path'] == _currentTrackPath)['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1,
                          value: _position.inSeconds.toDouble() < _duration.inSeconds.toDouble() 
                              ? _position.inSeconds.toDouble() 
                              : _duration.inSeconds.toDouble(),
                          onChanged: (value) {
                            final position = Duration(seconds: value.toInt());
                            _audioPlayer.seek(position);
                          },
                          activeColor: Colors.tealAccent,
                        ),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_down, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _volume = _volume > 0.1 ? _volume - 0.1 : 0;
                            _audioPlayer.setVolume(_volume);
                          });
                        },
                      ),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: 1,
                          value: _volume,
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                              _audioPlayer.setVolume(_volume);
                            });
                          },
                          activeColor: Colors.tealAccent,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _volume = _volume < 0.9 ? _volume + 0.1 : 1.0;
                            _audioPlayer.setVolume(_volume);
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                        onPressed: () {
                          // Find current track index
                          final currentIndex = _tracks.indexWhere((track) => track['path'] == _currentTrackPath);
                          if (currentIndex > 0) {
                            _playAudio(_tracks[currentIndex - 1]['path']!);
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: Colors.tealAccent,
                          size: 64,
                        ),
                        onPressed: () {
                          if (_currentTrackPath != null) {
                            _playAudio(_currentTrackPath!);
                          } else if (_tracks.isNotEmpty) {
                            // Play the first track if none is selected
                            _playAudio(_tracks[0]['path']!);
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
                        onPressed: () {
                          // Find current track index
                          final currentIndex = _tracks.indexWhere((track) => track['path'] == _currentTrackPath);
                          if (currentIndex < _tracks.length - 1) {
                            _playAudio(_tracks[currentIndex + 1]['path']!);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          
          // Track list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tracks.length,
              itemBuilder: (context, index) {
                final track = _tracks[index];
                final isCurrentTrack = _currentTrackPath == track['path'];
                
                return Card(
                  color: isCurrentTrack ? const Color(0xFF3E3E70) : const Color(0xFF2C2C54),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: Icon(
                      isCurrentTrack && _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      color: Colors.tealAccent,
                      size: 42,
                    ),
                    title: Text(
                      track['title']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: isCurrentTrack ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () => _playAudio(track['path']!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SleepTimerPage extends StatefulWidget {
  @override
  _SleepTimerPageState createState() => _SleepTimerPageState();
}

class _SleepTimerPageState extends State<SleepTimerPage> {
  Duration _duration = const Duration(minutes: 10);
  bool _timerActive = false;
  Duration _remainingTime = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = _duration;
  }

  void _startTimer() {
    setState(() {
      _timerActive = true;
      _remainingTime = _duration;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        } else {
          _timerActive = false;
          _timer?.cancel();
          
          // Navigate to sleep2.dart when timer completes
          _navigateToSleepDashboard();
        }
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sleep timer started for ${_duration.inMinutes} minutes'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF2C2C54),
      ),
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    setState(() {
      _timerActive = false;
      _remainingTime = _duration;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sleep timer cancelled'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF2C2C54),
      ),
    );
  }

  // Fixed method to navigate directly to sleep dashboard
  void _navigateToSleepDashboard() {
    // Use pushReplacement to replace the current screen with the sleep dashboard
    // This prevents navigation stack issues
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SleepScheduleScreen(),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Timer', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0F1123),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Timer display
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2C2C54),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _formatDuration(_timerActive ? _remainingTime : _duration),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Timer controls
                if (!_timerActive)
                  Column(
                    children: [
                      const Text(
                        'Set Sleep Timer',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${_duration.inMinutes} min',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      Slider(
                        min: 5,
                        max: 60,
                        divisions: 11,
                        value: _duration.inMinutes.toDouble(),
                        activeColor: Colors.tealAccent,
                        onChanged: (value) {
                          setState(() {
                            _duration = Duration(minutes: value.toInt());
                            _remainingTime = _duration;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // Use a Column instead of Row to prevent overflow
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _startTimer,
                              icon: const Icon(Icons.timer),
                              label: const Text('Start Timer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _navigateToSleepDashboard,
                              icon: const Icon(Icons.nightlight_round),
                              label: const Text('Sleep Dashboard'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E3E70),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      const Text(
                        'Timer Active',
                        style: TextStyle(fontSize: 24, color: Colors.tealAccent),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Music will stop in ${_formatDuration(_remainingTime)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Use a Column instead of Row to prevent overflow
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _cancelTimer,
                              icon: const Icon(Icons.stop),
                              label: const Text('Cancel Timer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _navigateToSleepDashboard,
                              icon: const Icon(Icons.nightlight_round),
                              label: const Text('Sleep Dashboard'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E3E70),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}