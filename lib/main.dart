import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_event.dart';
// import 'package:quran_player/bloc/player_page/player_page_bloc.dart';
// import 'package:quran_player/bloc/player_page/player_page_event.dart';
import 'package:quran_player/repository/quran_repository.dart';
import 'package:quran_player/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final int number;

    return MultiBlocProvider(
        providers: [
          BlocProvider<HomePageBloc>(
                create: (context) => HomePageBloc(QuranRepository())..add(GetSurahList()),
            ),
          // Add Other Block Provider Here
          // BlocProvider<PlayerPageBloc>(
          //   create: (context) => PlayerPageBloc(QuranRepository())..add(FetchDetailSurah(number)),
          // ),
          ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Quran Audio Player",
          home: const HomePage(),
      )
      );


  }
}

