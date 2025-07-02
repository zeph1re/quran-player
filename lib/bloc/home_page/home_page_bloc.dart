import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/surah.dart';
import '../../repository/quran_repository.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final QuranRepository repository;
  List<Surah> surahList = [];

  HomePageBloc(this.repository) : super(HomePageInitial()) {
    on<GetSurahList>(onGetSurah);
    on<SearchSurah>(onSearchSurah);
  }

  Future<void> onGetSurah (GetSurahList event, Emitter<HomePageState> emit) async {
    emit(HomePageLoading());
    try{
      surahList = await repository.fetchSurahList();
      emit(HomePageLoaded(listSurah: surahList));
    }
    catch(e){
      emit(HomePageError(message: "$e"));
    }
  }

  void onSearchSurah(SearchSurah event, Emitter<HomePageState> emit) {
    final query = event.query.toLowerCase();
    final filtered = surahList.where((surah) =>
      surah.namaLatin.toLowerCase().contains(query) ||
        surah. arti.toLowerCase().contains(query) ||
        surah.nama.toLowerCase().contains(query)
    ).toList();
    emit(HomePageLoaded(listSurah: filtered));
  }



}