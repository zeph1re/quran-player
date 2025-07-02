class SurahDetail {
  final int number;
  final String name;
  final String latinName;
  final int totalVerses;
  final String landingPlace;
  final String meaning;
  final String description;
  final String audio;
  final List<Verses> verses;

  SurahDetail({
    required this.name,
    required this.number,
    required this.latinName,
    required this.totalVerses,
    required this.landingPlace,
    required this.meaning,
    required this.description,
    required this.audio ,
    required this.verses
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    return SurahDetail(
      number: json['nomor'],
      name: json['nama'] ?? '',
      latinName: json['nama_latin'] ?? '',
      totalVerses: json['jumlah_ayat'] ?? 0,
      landingPlace: json['tempat_turun'] ?? '',
      meaning: json['arti'] ?? '',
      description: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
      verses: (json['ayat'] as List).map((e) => Verses.fromJson(e)).toList(),
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


