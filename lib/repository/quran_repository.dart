import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../models/surah.dart';


class QuranRepository {
  final String baseUrl = 'https://open-api.my.id/api/quran/surah';

  Future<List<Surah>> fetchSurahList() async {
    final response = await http.get(Uri.parse(baseUrl));
    log("Response: ${response.statusCode}");
    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Surah.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil daftar surah');
    }
  }
}