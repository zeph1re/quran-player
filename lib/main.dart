import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_player/bloc/home_page/home_screen_bloc.dart';
import 'package:quran_player/bloc/home_page/home_screen_event.dart';
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

    return MultiBlocProvider(
        providers: [
          BlocProvider<HomeScreenBloc>(
                create: (context) => HomeScreenBloc(QuranRepository())..add(GetSurahList()),
            ),
          // Add Other Block Provider Here
          ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Quran Audio Player",
          home: const HomePage(),
      )
      );


  }
}

