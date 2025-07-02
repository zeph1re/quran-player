import 'package:quran_player/models/surah_detail.dart';

class PlayerPageState {}

class PlayerPageInitial extends PlayerPageState {}

class PlayerPageLoading extends PlayerPageState {}

class PlayerPageLoaded extends PlayerPageState {
  final SurahDetail surahDetail;

  PlayerPageLoaded(this.surahDetail);
}

class PlayerPageError extends PlayerPageState {
  final String message;

  PlayerPageError(this.message);
}

