import 'package:flutter_bloc/flutter_bloc.dart' ;
import 'package:quran_player/bloc/player_page/player_page_event.dart';
import 'package:quran_player/bloc/player_page/player_page_state.dart';
import 'package:quran_player/repository/quran_repository.dart';

class PlayerPageBloc extends Bloc<PlayerPageEvent, PlayerPageState>{
  final QuranRepository repository;

  PlayerPageBloc(this.repository) : super(PlayerPageInitial()) {
   on<FetchDetailSurah>(onGetDetailSurah);
  }

  Future<void> onGetDetailSurah (FetchDetailSurah event, Emitter<PlayerPageState> emit) async {
    emit(PlayerPageLoading());
    try {
      final detail = await repository.fetchSurahDetail(event.number);
      emit(PlayerPageLoaded(detail));
    } catch (e) {
      emit(PlayerPageError(e.toString()));
    }
  }

}