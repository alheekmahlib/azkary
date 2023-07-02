class Class {
  final String number;
  final String title;
  final List<Page> pages;

  Class({required this.number, required this.title, required this.pages});

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      number: json['number'],
      title: json['title'],
      pages: (json['pages'] as List)
          .map((i) => Page.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Page {
  final String pageNumber;
  final String text;
  final String footnote;
  final String title;

  Page({required this.pageNumber, required this.text, required this.footnote, required this.title});

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      pageNumber: json['page'],
      text: json['text'],
      footnote: json['footnote'],
      title: json['title'],
    );
  }
}
