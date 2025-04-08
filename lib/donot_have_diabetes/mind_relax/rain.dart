import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class RainScreen extends StatefulWidget {
  const RainScreen({Key? key}) : super(key: key);

  @override
  State<RainScreen> createState() => _ForestScreenState();
}

class _ForestScreenState extends State<RainScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double _volume = 0.5;
  int _selectedTrackIndex = 0;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'Light Rain',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/rain/rain-sounds.mp3',
    },
    {
      'title': 'Rain on Umbrella',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/rain/lluvia-relajante-rain.mp3',
    },
    {
      'title': 'Heavy Rain',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/rain/november-rain.mp3',
    },
    {
      'title': 'Rain on Road',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/rain/rain-inside-a-car.mp3',
    },
    {
      'title': 'Rain Drops',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/rain/outdoor-rain-hujan.mp3',
    },
    {
      'title': 'Rain Story',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/rain/15-minutes-of-rain-sound-for-relaxation-and-sleep-study.mp3',
    },
    {
      'title': 'Rain Music',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/rain/rain-sounds.mp3',
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
        title: const Text('Rain Sounds'),
        backgroundColor: const Color.fromARGB(255, 119, 205, 229),
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
                    image: AssetImage('lib/donot_have_diabetes/mind_relax/mind images/rain.png'),
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
                      'Immerse yourself in the peaceful sounds of nature',
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
                                color: _selectedTrackIndex == index
                                    ? const Color.fromARGB(255, 74, 187, 193)
                                    : const Color.fromARGB(255, 158, 224, 255),
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
                          color: const Color.fromARGB(255, 125, 208, 243),
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
