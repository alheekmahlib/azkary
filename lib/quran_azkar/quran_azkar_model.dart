class Surah {
  final int surah;
  final String name;
  final List<Ayah> ayahs;

  Surah({required this.surah, required this.name, required this.ayahs});

  factory Surah.fromJson(Map<String, dynamic> json) {
    var list = json['ayahs'] as List;
    List<Ayah> ayahList = list.map((i) => Ayah.fromJson(i)).toList();

    return Surah(
      surah: int.parse(json['surah']),
      name: json['name'],
      ayahs: ayahList,
    );
  }
}

class Ayah {
  final String ayahNumber;
  final String ayah;

  Ayah({required this.ayahNumber, required this.ayah});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      ayahNumber: json['ayahNumber'],
      ayah: json['ayah'],
    );
  }
}
