import 'package:quran_player/models/surah.dart';

class HomePageState {}

class HomePageInitial extends HomePageState{}

class HomePageLoading extends HomePageState{}

class HomePageLoaded extends HomePageState{

  final List<Surah> listSurah;

  HomePageLoaded({
    required this.listSurah
  });
}

class HomePageError extends HomePageState{
  final String message;

  HomePageError({
   required this.message
  });
}