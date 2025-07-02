import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah.dart';

class SurahDetailPage extends StatefulWidget {
  final Surah surah;

  const SurahDetailPage({super.key, required this.surah});

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  late AudioPlayer _player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    initPlayer();
  }

  Future<void> initPlayer() async {
    _prefs = await SharedPreferences.getInstance();

    // Load saved position (if any)
    int lastPosition = _prefs.getInt('surah_${widget.surah.nomor}_position') ?? 0;
    _position = Duration(seconds: lastPosition);

    await _player.setUrl(widget.surah.audio);
    await _player.seek(_position);

    // Listen for updates
    _player.positionStream.listen((pos) {
      setState(() {
        _position = pos;
      });
      _prefs.setInt('surah_${widget.surah.nomor}_position', pos.inSeconds);
    });

    _player.durationStream.listen((dur) {
      if (dur != null) {
        setState(() {
          _duration = dur;
        });
      }
    });
  }

  void togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void seekTo(double value) {
    final newDuration = Duration(seconds: value.toInt());
    _player.seek(newDuration);
  }

  String format(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.namaLatin   ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.surah.nama, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.surah.arti, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            SizedBox(height: 12),
            Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(widget.surah.deskripsi.replaceAll(RegExp(r'<[^>]*>'), '')),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(_isPlaying ? 'Pause' : 'Play Audio'),
              onPressed: togglePlay,
            ),
            Slider(
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
              onChanged: seekTo,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(format(_position)),
                Text(format(_duration)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
