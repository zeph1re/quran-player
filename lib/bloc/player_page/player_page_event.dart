abstract class PlayerPageEvent {}

class LoadSurahDetail extends PlayerPageEvent {
  final int number;
  LoadSurahDetail(this.number);
}

class PlayAudio extends PlayerPageEvent {}

class PauseAudio extends PlayerPageEvent {}

class SeekAudio extends PlayerPageEvent {
  final Duration position;
  SeekAudio(this.position);
}

class NextSurah extends PlayerPageEvent {}

class PreviousSurah extends PlayerPageEvent {}
