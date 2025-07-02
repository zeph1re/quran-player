import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_player/bloc/player_page/player_page_event.dart';
import 'package:quran_player/bloc/player_page/player_page_state.dart';
import 'package:quran_player/models/surah_detail.dart';
import 'package:quran_player/repository/quran_repository.dart';

class PlayerPageBloc extends Bloc<PlayerPageEvent, PlayerPageState> {
  final QuranRepository repository;
  final AudioPlayer audioPlayer = AudioPlayer();

  SurahDetail? currentSurah;

  PlayerPageBloc(this.repository) : super(PlayerPageInitial()) {

    on<LoadSurahDetail>(_onLoadSurahDetail);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<SeekAudio>(_onSeekAudio);
    on<NextSurah>(_onNextSurah);
    on<PreviousSurah>(_onPreviousSurah);
  }

  Future<void> _onLoadSurahDetail(LoadSurahDetail event, Emitter<PlayerPageState> emit) async {
    emit(PlayerPageLoading());
    try {
      final surah = await repository.fetchSurahDetail(event.number);
      currentSurah = surah;
      String audioUrl = currentSurah!.audio;

      await audioPlayer.stop();
      await audioPlayer.setUrl(audioUrl);
      _emitPlayerState(emit, isPlaying: false, position: Duration.zero);

    } catch (e) {
      emit(PlayerPageError("Gagal memuat surah: $e"));
    }
  }

  void _onPlayAudio(PlayAudio event, Emitter<PlayerPageState> emit) async {
    if(!audioPlayer.playing) {
      try {
        await audioPlayer.play();
        _emitPlayerState(emit);
      } catch (e) {
        emit(PlayerPageError("Gagal memutar audio: $e"));
      }
    }
  }

  void _onPauseAudio(PauseAudio event, Emitter<PlayerPageState> emit) async {
    if(audioPlayer.playing) {
      try {
        await audioPlayer.pause();
        _emitPlayerState(emit);
      } catch (e) {
        emit(PlayerPageError("Gagal menjeda audio: $e"));
      }
    }
  }

  void _onSeekAudio(SeekAudio event, Emitter<PlayerPageState> emit) async {
    await audioPlayer.seek(event.position);
    if (currentSurah != null) {
      _emitPlayerState(emit, position: event.position);
    }
  }

  void _onNextSurah(NextSurah event, Emitter<PlayerPageState> emit) {
    final next = currentSurah?.nextSurah?.number;
    if (next != null) {
      add(LoadSurahDetail(next));
    }
  }

  void _onPreviousSurah(PreviousSurah event, Emitter<PlayerPageState> emit) {
    final prev = currentSurah?.prevSurah?.number;
    if (prev != null) {
      add(LoadSurahDetail(prev));
    }
  }

  void _emitPlayerState( Emitter<PlayerPageState> emit, {
        bool? isPlaying,
        Duration? position,
      }) {
    if (currentSurah == null) return;

    emit(PlayerPageLoaded(
      surah: currentSurah!,
      isPlaying: isPlaying ?? audioPlayer.playing,
      position: position ?? audioPlayer.position,
      duration: audioPlayer.duration ?? Duration.zero,
    ));
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
