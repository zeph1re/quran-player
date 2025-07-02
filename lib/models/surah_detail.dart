class SurahDetail {
  final bool status;
  final int number;
  final String name;
  final String latinName;
  final int totalVerses;
  final String landingPlace;
  final String meaning;
  final String description;
  final String audio;
  final List<Verses> verses;
  final SurahSummary? prevSurah;
  final SurahSummary? nextSurah;

  SurahDetail({
    required this.status,
    required this.name,
    required this.number,
    required this.latinName,
    required this.totalVerses,
    required this.landingPlace,
    required this.meaning,
    required this.description,
    required this.audio ,
    required this.verses,
    this.prevSurah,
    this.nextSurah
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    return SurahDetail(
      status: json['status'],
      number: json['nomor'],
      name: json['nama'] ?? '',
      latinName: json['nama_latin'] ?? '',
      totalVerses: json['jumlah_ayat'] ?? 0,
      landingPlace: json['tempat_turun'] ?? '',
      meaning: json['arti'] ?? '',
      description: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
      verses: (json['ayat'] as List).map((e) => Verses.fromJson(e)).toList(),
      prevSurah: json['surat_sebelumnya'] != null &&
          json['surat_sebelumnya'] is Map
          ? SurahSummary.fromJson(json['surat_sebelumnya'])
          : null,
      nextSurah: json['surat_selanjutnya'] != null &&
          json['surat_selanjutnya'] is Map
          ? SurahSummary.fromJson(json['surat_selanjutnya'])
          : null,

    );
  }
}


class Verses{
  final int surahNumber;
  final int versesNumber;
  final String arabicText;
  final String latinText;
  final String idnText;

  Verses({
    required this.surahNumber,
    required this.versesNumber,
    required this.arabicText,
    required this.latinText,
    required this.idnText
  });

  factory Verses.fromJson(Map<String, dynamic> json) {
    return Verses(
      surahNumber: json['surah'] ?? '',
      versesNumber: json['nomor'] ?? 0,
      arabicText: json['ar'] ?? '',
      latinText: json['tr'] ?? '',
      idnText: json['idn'] ?? ''
    );
  }

}

class SurahSummary {
  final int number;
  final String latinName;

  SurahSummary({
    required this.number,
    required this.latinName
});

  factory SurahSummary.fromJson(Map<String, dynamic> json) {
    return SurahSummary(
      number: json['nomor'] ?? 0,
      latinName: json['nama_latin'] ?? '',
    );
  }
}


