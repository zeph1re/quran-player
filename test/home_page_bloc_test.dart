import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player/bloc/home_page/home_page_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_event.dart';
import 'package:quran_player/bloc/home_page/home_page_state.dart';
import 'package:quran_player/models/surah.dart';
import 'package:quran_player/repository/quran_repository.dart';

import 'FakeQuranRepository.dart';

class FakeSurahRepository {
  Future<List<Surah>> getAllSurah() async {
    return [
      Surah(number: 1, name: "الفاتحة", latinName: "Al-Fatihah", totalVerses: 7, landingPlace: '', meaning: '', description: '', audio: ''),
      Surah(number: 2, name: "البقرة", latinName: "Al-Baqarah", totalVerses: 286, landingPlace: '', meaning: '', description: '', audio: ''),
    ];
  }

  Future<List<Surah>> searchSurah(String query) async {
    return [
      Surah(number: 2, name: "البقرة", latinName: "Al-Baqarah", totalVerses: 286, landingPlace: '', meaning: '', description: '', audio: ''),
    ];
  }
}

void main() {
  group("HomePageBloc", () {
    late HomePageBloc bloc;

    setUp(() {
      bloc = HomePageBloc(FakeQuranRepository());
    });

    test("emits [Loading, Loaded] when FetchSurah is added", () async {
      final expectedStates = [
        isA<HomePageLoading>(),
        isA<HomePageLoaded>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(GetSurahList());
    });

    test("emits [Loaded] with filtered surah when SearchSurah is added", () async {
      final expectedStates = [
        isA<HomePageLoaded>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(SearchSurah("baqarah"));
    });
  });
}
