import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_player/bloc/player_page/player_page_bloc.dart';
import 'package:quran_player/bloc/player_page/player_page_event.dart';
import 'package:quran_player/bloc/player_page/player_page_state.dart';
import 'package:quran_player/repository/quran_repository.dart';

class PlayerPage extends StatelessWidget {
  final int surahNumber;

  const PlayerPage({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayerPageBloc(QuranRepository())
        ..add(LoadSurahDetail(surahNumber)),
      child: BlocBuilder<PlayerPageBloc, PlayerPageState>(
        builder: (context, state) {
          if (state is PlayerPageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlayerPageLoaded) {
            final surah = state.surah;
            return Scaffold(
              appBar: AppBar(title: Text('${surah.latinName}')),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Column(
                      children: [
                        Text(surah.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(surah.meaning),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(state.position)),
                        Text(_formatDuration(state.duration)),
                      ],
                    ),
                  ),
                  Slider(
                    value: state.position.inSeconds.toDouble().clamp(0, state.duration.inSeconds.toDouble()),
                    max: state.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      context.read<PlayerPageBloc>().add(
                        SeekAudio(Duration(seconds: value.toInt())),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: state.surah.prevSurah != null
                            ? () => context.read<PlayerPageBloc>().add(PreviousSurah())
                            : null,
                      ),
                      IconButton(
                        icon: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: () {
                          context.read<PlayerPageBloc>().add(
                            state.isPlaying ? PauseAudio() : PlayAudio(),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: state.surah.nextSurah != null
                            ? () => context.read<PlayerPageBloc>().add(NextSurah())
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: surah.verses.length,
                      itemBuilder: (context, index) {
                        final verse = surah.verses[index];
                        return ListTile(
                          title: Padding(padding: EdgeInsets.only(bottom: 30),
                            child: Text(verse.arabicText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.right,),
                          ),
                          subtitle: Text(verse.idnText),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is PlayerPageError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours.remainder(60));
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$hours:$minutes:$seconds";
}
