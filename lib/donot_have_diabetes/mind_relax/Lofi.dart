import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class LofiScreen extends StatefulWidget {
  const LofiScreen({Key? key}) : super(key: key);

  @override
  State<LofiScreen> createState() => _LofiScreenState();
}

class _LofiScreenState extends State<LofiScreen> {
  bool isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _volume = 0.5;
  int _currentTrackIndex = 0;

  final List<Map<String, String>> _tracks = [
    {
      'name': 'Lofi Guitar Jazz',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/jazz/lofi-guitar-jazz.mp3',
    },
    {
      'name': 'Lofi Chill Jazz',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/jazz/lofi-chill-jazz.mp3',
    },
    {
      'name': 'The Best Jazz Club in New Orleans',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/jazz/the-best-jazz-club-in-new-orleans..mp3',
    },
    {
      'name': 'A Call to the Soul',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/jazz/a-call-to-the-soul.mp3',
    },
    {
      'name': 'Lofi Jazz Background Music',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/jazz/lofi-jazz-background-music.mp3',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setAsset(_tracks[_currentTrackIndex]['path']!);
      _audioPlayer.setVolume(_volume);
    } catch (e) {
      print('Audio load error: $e');
    }

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextTrack();
      }
    });
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _setVolume(double value) {
    setState(() {
      _volume = value;
    });
    _audioPlayer.setVolume(value);
  }

  void _playNextTrack() {
    int nextIndex = (_currentTrackIndex + 1) % _tracks.length;
    _changeTrack(nextIndex);
  }

  Future<void> _changeTrack(int index) async {
    if (index == _currentTrackIndex) return;

    setState(() {
      _currentTrackIndex = index;
    });

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setAsset(_tracks[_currentTrackIndex]['path']!);
      if (isPlaying) {
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error changing track: $e');
    }
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
        title: const Text('Lofi Beats'),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image section
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/donot_have_diabetes/mind_relax/mind images/lofi.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Controls section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _tracks[_currentTrackIndex]['name']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Chill beats to relax and study to',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Track selection
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
                                color: _currentTrackIndex == index
                                    ? Colors.indigo.shade700
                                    : Colors.indigo.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _tracks[index]['name']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _currentTrackIndex == index
                                          ? Colors.white
                                          : Colors.black87,
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

                    // Play/pause button
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Volume slider
                    Row(
                      children: [
                        const Icon(Icons.volume_down),
                        Expanded(
                          child: Slider(
                            value: _volume,
                            onChanged: _setVolume,
                            activeColor: Colors.indigo.shade600,
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
