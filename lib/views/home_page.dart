import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_player/bloc/home_page/home_screen_bloc.dart';
import 'package:quran_player/bloc/home_page/home_screen_event.dart';
import 'package:quran_player/bloc/home_page/home_screen_state.dart';
import 'package:quran_player/models/surah.dart';
import 'package:quran_player/repository/quran_repository.dart';
import 'package:quran_player/views/player_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (_) => HomeScreenBloc(QuranRepository())..add(GetSurahList()),
      child: Scaffold(
        appBar: AppBar(title: Text('Daftar Surah')),
        body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, state) {
            if (state is HomeScreenLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is HomeScreenLoaded) {
              return ListView.builder(
                itemCount: state.listSurah.length,
                itemBuilder: (context, index) {
                  Surah surah = state.listSurah[index];
                  return ListTile(
                    title: Text('${surah.nomor}. ${surah.namaLatin}'),
                    subtitle: Text('${surah.arti} - ${surah.tempatTurun} (${surah.jumlahAyat} ayat)'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurahDetailPage(surah: surah),
                        ),
                      );
                    },
                  );
                },
              );
            }
            else if (state is HomeScreenError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
