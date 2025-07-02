class SurahDetail {
  late int number;
  late String name;
  late String latinName;
  late String audio;
  late List<Verses> verses;

  SurahDetail({
    required this.name,
    required this.number,
    required this.latinName,
    required this.audio,
    required this.verses
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    return SurahDetail(
      number: json['nomor'],
      name: json['nama'],
      latinName: json['namaLatin'],
      audio: json['audio'],
      verses: (json['ayat'] as List).map((e) => Verses.fromJson(e)).toList(),
    );
  }
}


class Verses{
  late int id;
  late int surahNumber;
  late int versesNumber;
  late String arabicText;
  late String latinText;
  late String idnText;

  Verses({
    required this.id,
    required this.surahNumber,
    required this.versesNumber,
    required this.arabicText,
    required this.latinText,
    required this.idnText
  });

  factory Verses.fromJson(Map<String, dynamic> json) {
    return Verses(
      id: json['id'],
      surahNumber: json['surah'],
      versesNumber: json['nomor'],
      arabicText: json['ar'],
      latinText: json['tr'],
      idnText: json['idn']
    );
  }

}


