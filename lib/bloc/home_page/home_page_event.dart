class HomePageEvent {}

class GetSurahList extends HomePageEvent {}

class SearchSurah extends HomePageEvent {
  final String query;

  SearchSurah(this. query);

  List<Object?> get props => [query];

}