import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_event.dart';
import 'package:quran_player/bloc/home_page/home_page_state.dart';
import 'package:quran_player/views/player_page.dart' show PlayerPage;


class HomePage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quran Audio Player")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<HomePageBloc>().add(SearchSurah(value));
              },
              decoration: InputDecoration(
                hintText: "Search Surah...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                if (state is HomePageLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is HomePageLoaded) {
                  return ListView.builder(
                    itemCount: state.listSurah.length,
                    itemBuilder: (context, index) {
                      final surah = state.listSurah[index];
                      return ListTile(
                        title: Text("${surah.number}. ${surah.latinName}"),
                        subtitle: Text(surah.name),
                        trailing: Text("${surah.totalVerses} Ayat"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerPage(surahNumber: surah.number,),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is HomePageError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
