import 'package:quran_player/models/surah.dart';
import 'package:quran_player/models/surah_detail.dart';
import 'package:quran_player/repository/quran_repository.dart';

class FakeQuranRepository implements QuranRepository {
  final List<Surah> _dummySurahList = [
    Surah(number: 1, name: "الفاتحة", latinName: "Al-Fatihah", totalVerses: 7, landingPlace: '', meaning: '', description: '', audio: ''),
    Surah(number: 2, name: "البقرة", latinName: "Al-Baqarah", totalVerses: 286, landingPlace: '', meaning: '', description: '', audio: ''),
    Surah(number: 3, name: "آل عمران", latinName: "Ali Imran", totalVerses: 200, landingPlace: '', meaning: '', description: '', audio: ''),
  ];

  final _dummyDetailSurah = SurahDetail(status: true, name: "Al-Fatihah", number: 1, latinName: '', totalVerses: 7, landingPlace: '', meaning: '', description: '', audio: '', verses: []);

  @override
  // TODO: implement baseUrl
  String get baseUrl => throw UnimplementedError();

  @override
  Future<SurahDetail> fetchSurahDetail(int number) async {
    // TODO: implement fetchSurahDetail
    await Future.delayed(Duration(milliseconds: 100));
    return _dummyDetailSurah;
  }

  @override
  Future<List<Surah>> fetchSurahList() async {
    // TODO: implement fetchSurahList
    await Future.delayed(Duration(milliseconds: 100));
    return _dummySurahList;
  }
}