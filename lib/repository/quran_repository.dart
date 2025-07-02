import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';
import '../models/surah_detail.dart';


class QuranRepository {
  final String baseUrl = 'https://open-api.my.id/api/quran/surah';

  Future<List<Surah>> fetchSurahList() async {
    final response = await http.get(Uri.parse(baseUrl));
    // log("Response: ${response.statusCode}");
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Surah.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil daftar surah');
    }
  }

  Future<SurahDetail> fetchSurahDetail(int number) async {
    final response = await http.get(Uri.parse('$baseUrl/$number'));
    // response 200
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SurahDetail.fromJson(json);
    } else {
      throw Exception('Gagal mengambil detail surah');
    }
  }


}