import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/surah.dart';
import '../../repository/quran_repository.dart';
import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final QuranRepository repository;

  HomeScreenBloc(this.repository) : super(HomeScreenInitial()) {
    on<GetSurahList>((event, emit) async {
      emit(HomeScreenLoading());
      try{
        final List<Surah> surahList = await repository.fetchSurahList();
        print("Hello");
        emit(HomeScreenLoaded(listSurah: surahList));
      }
      catch(e){
        emit(HomeScreenError(message: "$e"));
      }

    });
  }

}