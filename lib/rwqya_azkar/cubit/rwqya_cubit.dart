import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../model/rwqya_model.dart';

part 'rwqya_state.dart';

class RwqyaCubit extends Cubit<List<Rwqya>> {
  RwqyaCubit() : super([]);

  Future<void> loadData() async {
    final response = await rootBundle.loadString('assets/books/rwqya.json');
    final data = await json.decode(response);
    final rwqyaList = (data as List).map((i) => Rwqya.fromJson(i)).toList();

    emit(rwqyaList);
  }
}
