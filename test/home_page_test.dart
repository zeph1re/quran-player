import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quran_player/bloc/home_page/home_page_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_event.dart';
import 'package:quran_player/bloc/home_page/home_page_state.dart';
import 'package:quran_player/models/surah.dart';
import 'package:quran_player/views/home_page.dart';

/// FakeBloc buatan tangan untuk mengganti BLoC asli
class FakeHomePageBloc extends Cubit<HomePageState> implements HomePageBloc {
  FakeHomePageBloc(super.initialState);

  @override
  void add(HomePageEvent event) {
    // Tidak melakukan apa-apa, cukup untuk test UI statis
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('HomePage Widget Test', () {
    late HomePageBloc fakeBloc;

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<HomePageBloc>.value(
          value: fakeBloc,
          child: const HomePage(),
        ),
      );
    }

    testWidgets('Tampilkan loading saat state HomePageLoading', (tester) async {
      fakeBloc = FakeHomePageBloc(HomePageLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Tampilkan error saat state HomePageError', (tester) async {
      fakeBloc = FakeHomePageBloc(HomePageError(message: 'Terjadi kesalahan'));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Error'), findsOneWidget);
    });

    testWidgets(
        'Tampilkan daftar surah saat state HomePageLoaded', (tester) async {
      final surahList = [
        Surah(
          number: 1,
          name: 'الفاتحة',
          latinName: 'Al-Fatihah',
          totalVerses: 7,
          landingPlace: 'mekah',
          meaning: 'Pembukaan',
          description: '',
          audio: '',
        ),
        Surah(
          number: 2,
          name: 'البقرة',
          latinName: 'Al-Baqarah',
          totalVerses: 286,
          landingPlace: 'madinah',
          meaning: 'Sapi',
          description: '',
          audio: '',
        ),
      ];

      fakeBloc = FakeHomePageBloc(HomePageLoaded(listSurah: surahList));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Al-Fatihah'), findsOneWidget);
      expect(find.textContaining('Al-Baqarah'), findsOneWidget);
    });

    testWidgets('TextField pencarian bisa diketik', (tester) async {
      fakeBloc = FakeHomePageBloc(HomePageLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Al-Fa');
      expect(find.text('Al-Fa'), findsOneWidget);
    });
  });
}
