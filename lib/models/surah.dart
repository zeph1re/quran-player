class Surah {
  final int number;
  final String name;
  final String latinName;
  final int totalVerses;
  final String landingPlace;
  final String meaning;
  final String description;
  final String audio;

  Surah({
    required this.number,
    required this.name,
    required this.latinName,
    required this.totalVerses,
    required this.landingPlace,
    required this.meaning,
    required this.description,
    required this.audio,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['nomor'],
      name: json['nama'],
      latinName: json['nama_latin'],
      totalVerses: json['jumlah_ayat'],
      landingPlace: json['tempat_turun'],
      meaning: json['arti'],
      description: json['deskripsi'],
      audio: json['audio'],
    );
  }
}
