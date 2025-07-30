// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';

// import '../quran_azkar_model.dart';

// part 'quran_azkar_state.dart';

// class QuranAzkarCubit extends Cubit<List<Surah>> {
//   QuranAzkarCubit() : super([]);

//   Future<void> loadData() async {
//     final response = await rootBundle.loadString('assets/books/quran_azkar.json');
//     final data = await json.decode(response);
//     final surahs = (data['surahs'] as List).map((i) => Surah.fromJson(i)).toList();

//     emit(surahs);
//   }
// }
