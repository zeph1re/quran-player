import 'package:quran_player/models/surah_detail.dart';

abstract class PlayerPageState {

  @override
  List<Object?> get props => [];
}

class PlayerPageInitial extends PlayerPageState {}

class PlayerPageLoading extends PlayerPageState {}

class PlayerPageLoaded extends PlayerPageState {
  final SurahDetail surah;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  PlayerPageLoaded({
    required this.surah,
    required this.isPlaying,
    required this.position,
    required this.duration,
  });

  @override
  List<Object?> get props => [surah, isPlaying, position, duration];
}

class PlayerPageError extends PlayerPageState {
  final String message;
  PlayerPageError(this.message);

  @override
  List<Object?> get props => [message];
}
