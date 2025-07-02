import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_player/bloc/player_page/player_page_bloc.dart';
import 'package:quran_player/bloc/player_page/player_page_event.dart';
import 'package:quran_player/bloc/player_page/player_page_state.dart';
import 'package:quran_player/repository/quran_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlayerPage extends StatefulWidget {
  final int number;

  const PlayerPage({super.key, required this.number});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late AudioPlayer _player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _setupAudio(String audioUrl, int surahNomor) async {
    final savedPosition = _prefs.getInt('pos_$surahNomor') ?? 0;
    await _player.setUrl(audioUrl);
    await _player.seek(Duration(seconds: savedPosition));

    _player.positionStream.listen((pos) {
      setState(() => _position = pos);
      _prefs.setInt('pos_$surahNomor', pos.inSeconds);
    });

    _player.durationStream.listen((dur) {
      if (dur != null) setState(() => _duration = dur);
    });
  }

  void _togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  void _seek(double value) {
    final newPos = Duration(seconds: value.toInt());
    _player.seek(newPos);
  }

  String _format(Duration dur) {
    final m = dur.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = dur.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayerPageBloc(QuranRepository())..add(FetchDetailSurah(widget.number)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Detail Surah')),
        body: BlocBuilder<PlayerPageBloc, PlayerPageState>(
          builder: (context, state) {
            if (state is PlayerPageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlayerPageLoaded) {
              final surah = state.surahDetail;

              // Mulai setup audio player jika belum
              _setupAudio(surah.audio, surah.number);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('${surah.latinName} (${surah.meaning})', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${surah.totalVerses} ayat - ${surah.landingPlace.toUpperCase()}'),
                  const SizedBox(height: 12),
                  Text(surah.description.replaceAll(RegExp(r'<[^>]*>'), '')),
                  const SizedBox(height: 20),

                  // AUDIO PLAYER
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        label: Text(_isPlaying ? 'Pause Audio' : 'Play Audio'),
                        onPressed: _togglePlayback,
                      ),
                      Slider(
                        value: _position.inSeconds.toDouble(),
                        max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1,
                        onChanged: _seek,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_format(_position)),
                          Text(_format(_duration)),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 32),
                  const Text('Daftar Ayat:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // ...surah.verses.map((a) => ListTile(
                  //   title: Text(a!.arabicText, textAlign: TextAlign.right, style: const TextStyle(fontSize: 20)),
                  //   subtitle: Text(a!.idnText),
                  // )),
                ],
              );
            } else if (state is PlayerPageError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
