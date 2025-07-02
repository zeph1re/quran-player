import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_bloc.dart';
import 'package:quran_player/bloc/home_page/home_page_event.dart';
import 'package:quran_player/bloc/home_page/home_page_state.dart';
import 'package:quran_player/views/player_page.dart' show PlayerPage;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String query) {
    context.read<HomePageBloc>().add(SearchSurah(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Surah')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari surah...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                if (state is HomePageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomePageLoaded) {
                  final surahs = state.listSurah;
                  if (surahs.isEmpty) return const Center(child: Text('Tidak ada hasil'));
                  return ListView.builder(
                    itemCount: surahs.length,
                    itemBuilder: (context, index) {
                      final surah = surahs[index];
                      return ListTile(
                        title: Text('${surah.number}. ${surah.latinName}'),
                        subtitle: Text('${surah.meaning} - ${surah.landingPlace} (${surah.totalVerses} ayat)'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerPage( surahNumber: surah.number),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is HomePageError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
