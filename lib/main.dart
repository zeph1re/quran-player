import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_event.dart';
// import 'package:quran_player/bloc/player_page/player_page_bloc.dart';
// import 'package:quran_player/bloc/player_page/player_page_event.dart';
import 'package:quran_player/repository/quran_repository.dart';
import 'package:quran_player/views/home_page.dart';

void main() {
  final QuranRepository repository = QuranRepository();
  runApp(MyApp(repo: repository,));
}

class MyApp extends StatelessWidget {
  final QuranRepository repo;
  const MyApp({required this.repo});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Audio',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => HomePageBloc(repo)..add(GetSurahList()),
        child: HomePage(),
      ),
    );
  }
}
