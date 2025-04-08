import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ForestScreen extends StatefulWidget {
  const ForestScreen({Key? key}) : super(key: key);

  @override
  State<ForestScreen> createState() => _ForestScreenState();
}

class _ForestScreenState extends State<ForestScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double _volume = 0.5;
  int _selectedTrackIndex = 0;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'Jungle Style Videogame',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/forest/jungle-style-videogame.mp3',
    },
    {
      'title': 'Jungle Vibes',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/forest/jungle-vibes.mp3',
    },
    {
      'title': 'Jungle Party',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/forest/jungle-party.mp3',
    },
    {
      'title': 'Jungle-ish Beat',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/forest/jungle-ish-beat-for-video-games.mp3',
    },
    {
      'title': 'Dance of the Jungle',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/forest/dance-of-the-jungle.mp3',
    },
    {
      'title': 'Jungle Story',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/forest/dance-of-the-jungle.mp3',
    },
    {
      'title': 'Jungle Music',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/forest/jungle-music.mp3',
    },
    {
      'title': 'Jungle Stomp',
      'path': 'lib/donot_have_diabetes/mind_relax/audio/forest/jungle-stomp.mp3',
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
        title: const Text('Forest Sounds'),
        backgroundColor: Colors.green.shade700,
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
                    image: AssetImage('lib/donot_have_diabetes/mind_relax/mind images/forest.jpg'),
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
                                    ? Colors.green.shade700
                                    : Colors.green.shade200,
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
                          color: Colors.green.shade700,
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
