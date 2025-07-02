import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player/bloc/home_page/home_page_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_event.dart';
import 'package:quran_player/bloc/home_page/home_page_state.dart';
import 'package:quran_player/models/surah.dart';
import 'package:quran_player/views/home_page.dart';
import 'dart:async';

/// Fake Bloc tanpa mocktail
class FakeHomePageBloc extends Bloc<HomePageEvent, HomePageState>
    implements HomePageBloc {
  final StreamController<HomePageState> _controller = StreamController();

  FakeHomePageBloc(HomePageState initialState) : super(initialState) {
    _controller.stream.listen(emit);
  }

  // Test Search Feature
  @override
  void add(HomePageEvent event) {
    if (event is SearchSurah) {
      _controller.add(HomePageLoaded( listSurah :[
        Surah(
            number: 2,
            name: 'البقرة',
            latinName: 'Al-Baqarah',
            totalVerses: 286, landingPlace: '', meaning: '', description: '', audio: ''),
      ], ));
    }
  }

  @override
  Future<void> close() {
    _controller.close();
    return super.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  // Loading Indicator
  testWidgets('Menampilkan CircularProgressIndicator saat loading',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<HomePageBloc>(
              create: (_) => FakeHomePageBloc(HomePageLoading()),
              child: HomePage(),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });


  // List Surah
  testWidgets('Menampilkan list surah saat HomePageLoaded',
          (WidgetTester tester) async {
        final state = HomePageLoaded(listSurah: [
          Surah(
              number: 1,
              name: 'الفاتحة',
          latinName: 'Al-Fatihah',
              totalVerses: 7, landingPlace: '', meaning: '', description: '', audio: ''  ,   ),
          Surah(
              number: 2,
              name: 'البقرة',
              latinName: 'Al-Baqarah',
              totalVerses: 286, landingPlace: '', meaning: '', description: '', audio: ''),
        ]);

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<HomePageBloc>(
              create: (_) => FakeHomePageBloc(state),
              child: HomePage(),
            ),
          ),
        );

        await tester.pump(); // allow state changes to rebuild UI

        expect(find.byType(ListTile), findsNWidgets(2));
        expect(find.text('1. Al-Fatihah'), findsOneWidget);
        expect(find.text('2. Al-Baqarah'), findsOneWidget);
      });

  // Home Error
  testWidgets('Menampilkan pesan error saat HomePageError',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<HomePageBloc>(
              create: (_) => FakeHomePageBloc(HomePageError(message: "Terjadi kesalahan")),
              child: HomePage(),
            ),
          ),
        );

        expect(find.textContaining("Terjadi kesalahan"), findsOneWidget);
      });

  // Search Surah
  testWidgets('Mengirim event SearchSurah saat teks diubah',
          (WidgetTester tester) async {
        final bloc = FakeHomePageBloc(HomePageLoaded(listSurah: []));

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<HomePageBloc>(
              create: (_) => bloc,
              child: HomePage(),
            ),
          ),
        );

        final searchField = find.byType(TextField);
        expect(searchField, findsOneWidget);

        await tester.enterText(searchField, "Baqarah");
        await tester.pump();

        expect(find.text("2. Al-Baqarah"), findsOneWidget);
      });
}
