class Rwqya {
  late final int id;
  final String category;
  final String count;
  final String description;
  final String reference;
  final String zekr;

  Rwqya({required this.category, required this.count, required this.description, required this.reference, required this.zekr});

  factory Rwqya.fromJson(Map<String, dynamic> json) {
    return Rwqya(
      // json['id'],
      category: json['category'],
      count: json['count'],
      description: json['description'],
      reference: json['reference'],
      zekr: json['zekr'],
    );
  }
}
