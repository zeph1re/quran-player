import 'package:quran_player/models/surah.dart';

class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState{}

class HomeScreenLoading extends HomeScreenState{}

class HomeScreenLoaded extends HomeScreenState{

  final List<Surah> listSurah;

  HomeScreenLoaded({
    required this.listSurah
  });
}

class HomeScreenError extends HomeScreenState{
  final String message;

  HomeScreenError({
   required this.message
  });
}