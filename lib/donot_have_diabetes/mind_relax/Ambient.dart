import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AmbientScreen extends StatefulWidget {
  const AmbientScreen({Key? key}) : super(key: key);

  @override
  State<AmbientScreen> createState() => _ForestScreenState();
}

class _ForestScreenState extends State<AmbientScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double _volume = 0.5;
  int _selectedTrackIndex = 0;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'Relaxing ambient',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/ambient/relaxing-ambient-music-nostalgic-memories.mp3',
    },
    {
      'title': 'Dark ambient',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/ambient/dark-ambient-music.mp3',
    },
    {
      'title': 'Medieval ambient',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/ambient/medieval-ambient.mp3',
    },
    {
      'title': 'Cosmic ambient',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/ambient/cosmic-ambient.mp3',
    },
    {
      'title': 'Nature ambient',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/ambient/documentary-nature-ambient.mp3',
    },
    {
      'title': 'spring ambient',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/ambient/spring-night-is-over-ambient-liminal-darkambient.mp3',
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
        setState(() {
          this.isPlaying = false;
        });
      }

      setState(() {
        this.isPlaying = isPlaying;
      });
    });
  }

  Future<void> _loadCurrentTrack() async {
    try {
      await _audioPlayer.setAsset(_tracks[_selectedTrackIndex]['path']!);
      await _audioPlayer.setVolume(_volume);
    } catch (e) {
      print('Error loading audio source: $e');
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
      setState(() {
        _selectedTrackIndex = index;
      });

      await _audioPlayer.stop();
      await _loadCurrentTrack();

      if (isPlaying) {
        await _audioPlayer.play();
      }
    }
  }

  void _setVolume(double value) {
    setState(() {
      _volume = value;
    });
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
        title: const Text('Ambient Sounds'),
        backgroundColor: const Color.fromARGB(255, 131, 69, 193),
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
                    image: AssetImage('lib/donot_have_diabetes/mind_relax/mind images/ambient.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Controls section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _tracks[_selectedTrackIndex]['title']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Drift away with calming ambient tones',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 180, 121, 206),
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
                                color: _selectedTrackIndex == index
                                    ? const Color.fromARGB(255, 187, 122, 207)
                                    : const Color.fromARGB(255, 240, 176, 240),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _tracks[index]['title']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _selectedTrackIndex == index
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

                    // Play button
                    GestureDetector(
                      onTap: _playPause,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 203, 158, 231),
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
