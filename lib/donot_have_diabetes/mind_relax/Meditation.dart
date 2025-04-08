import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double _volume = 0.5;
  int _selectedTrackIndex = 0;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'Morning Calm',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/deep-meditation.mp3',
    },
    {
      'title': 'Breath Focus',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/meditation-music-without-nature-sound.mp3',
    },
    {
      'title': 'Inner Peace',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/meditation-music.mp3',
    },
    {
      'title': 'Mindful Relax',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/meditation-relaxing-music.mp3',
    },
    {
      'title': 'Body Scan',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/meditation-relax-sleep-music.mp3',
    },
    {
      'title': 'Gratitude Flow',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/relaxing-meditation.mp3',
    },
    {
      'title': 'Ocean Breath',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/ocean-breath.mp3',
    },
    {
      'title': 'Stillness Practice',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/soothing-meditation-without-voice.mp3',
    },
    {
      'title': 'Self Compassion',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/the-old-water-mill-meditation.mp3',
    },
    {
      'title': 'Night Calm',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/meditation/night-calm.mp3',
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    await _loadCurrentTrack();
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (processingState == ProcessingState.completed) {
        setState(() => this.isPlaying = false);
      }

      setState(() => this.isPlaying = isPlaying);
    });
  }

  Future<void> _loadCurrentTrack() async {
    try {
      await _audioPlayer.setAsset(_tracks[_selectedTrackIndex]['path']!);
      await _audioPlayer.setVolume(_volume);
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  void _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  void _changeTrack(int index) async {
    if (_selectedTrackIndex != index) {
      setState(() => _selectedTrackIndex = index);
      await _audioPlayer.stop();
      await _loadCurrentTrack();
      await _audioPlayer.play();
    }
  }

  void _setVolume(double value) {
    setState(() => _volume = value);
    _audioPlayer.setVolume(value);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header image
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/donot_have_diabetes/mind_relax/mind images/medition.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _tracks[_selectedTrackIndex]['title']!,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Find peace and mindfulness with guided meditation',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),

                    // Track selector
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tracks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _changeTrack(index),
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: _selectedTrackIndex == index
                                    ? Colors.teal.shade700
                                    : Colors.teal.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _tracks[index]['title']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _selectedTrackIndex == index ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Play/Pause Button
                    GestureDetector(
                      onTap: _playPause,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),

                    // Volume slider
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Icon(Icons.volume_down),
                        Expanded(
                          child: Slider(
                            value: _volume,
                            onChanged: _setVolume,
                          ),
                        ),
                        const Icon(Icons.volume_up),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
