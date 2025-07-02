import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_player/bloc/player_page/player_page_bloc.dart';
import 'package:quran_player/bloc/player_page/player_page_event.dart';
import 'package:quran_player/bloc/player_page/player_page_state.dart';
import 'package:quran_player/repository/quran_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerPage extends StatefulWidget {
  final int surahNumber;

  const PlayerPage({super.key, required this.surahNumber});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();


  }

  Future<void> _initPrefs() async {
    // _prefs = await SharedPreferences.getInstance();
  }



  Future<void> _setupAudioPlayer(String url) async {
    final saved = _prefs?.getInt('pos_${widget.surahNumber}') ?? 0;
    await audioPlayer.setUrl(url);
    await audioPlayer.seek(Duration(seconds: saved));
    audioPlayer.positionStream.listen((p) {
      setState(() => _position = p);
      _prefs?.setInt('pos_${widget.surahNumber}', p.inSeconds);
    });
    audioPlayer.durationStream.listen((d) {
      if (d != null) setState(() => _duration = d);
    });
  }



  void _togglePlay() async {
    if (_isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String timeFormat(Duration d) {
    final h = d.inHours.remainder(60).toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayerPageBloc(QuranRepository())..add(FetchDetailSurah(widget.surahNumber)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Detail Surah')),
        body: BlocBuilder<PlayerPageBloc, PlayerPageState>(
          builder: (context, state) {
            if (state is PlayerPageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlayerPageLoaded) {
              final surah = state.surahDetail;
              _setupAudioPlayer(surah.audio);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Text(surah.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child:Text('${surah.latinName} (${surah.meaning})', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Text('${surah.totalVerses} ayat - ${surah.landingPlace.toUpperCase()}'),
                  const SizedBox(height: 12),
                  Text(surah.description.replaceAll(RegExp(r'<[^>]*>'), '')),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(timeFormat(_position)),
                      Text(timeFormat(_duration - _position)),
                    ],
                  ),
                  Slider(
                    min: 0,
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble().clamp(1, double.infinity),
                    onChanged: (v) => audioPlayer.seek(Duration(seconds: v.toInt())),
                  ),

                  const SizedBox(height: 12),
                  CircleAvatar(
                    radius: 20,
                    child: IconButton(
                      icon: Icon(
                          _isPlaying? Icons.pause : Icons.play_arrow,
                      ),
                      iconSize: 17,
                      onPressed: _togglePlay
                    ),

                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  // const Text('Ayat-ayat:', style: TextStyle(fontWeight: FontWeight.bold)),
                  // ...s.verses.map((a) => ListTile(
                  //   title: Text(a.arabicText, textAlign: TextAlign.right),
                  //   subtitle: Text(a.idnText),
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
