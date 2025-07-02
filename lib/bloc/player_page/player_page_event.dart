class PlayerPageEvent {}

class FetchDetailSurah extends PlayerPageEvent {
  final int number;
  FetchDetailSurah(this.number);
}