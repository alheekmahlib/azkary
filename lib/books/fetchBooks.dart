import 'dart:convert';
import 'package:flutter/services.dart';

import 'model/books_model.dart';

Future<List<Class>> fetchClasses() async {
  String jsonString = await rootBundle.loadString('assets/books/altib.json');
  final jsonResult = jsonDecode(jsonString);
  return (jsonResult['class'] as List)
      .map((i) => Class.fromJson(i as Map<String, dynamic>))
      .toList();
}
