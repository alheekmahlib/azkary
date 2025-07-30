// import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
// import '../../azkar/models/azkar.dart';
// import '../../database/databaseHelper.dart';
// import '../../l10n/app_localizations.dart';
// import '../../../shared/widgets/widgets.dart';

// part 'azkar_state.dart';

// class AzkarCubit extends Cubit<AzkarState> {
//   AzkarCubit() : super(AzkarInitial());

//   Future<int?> addAzkar(Azkar? azkar) {
//     print('Adding azkar: $azkar');
//     return DatabaseHelper.addAzkar(azkar!);
//   }

//   Future<void> getAzkar() async {
//     try {
//       final List<Map<String, dynamic>> azkar = await DatabaseHelper.queryC();
//       print('Retrieved azkar: $azkar');
//       emit(AzkarLoaded(azkar.map((data) => Azkar.fromJson(data)).toList()));
//     } catch (e) {
//       print('Error getting azkar: $e');
//       emit(AzkarError());
//     }
//   }

//   Future<void> deleteAzkar(Azkar? azkar, BuildContext context) async {
//     try {
//       print('Deleting azkar: $azkar');
//       await DatabaseHelper.deleteAzkar(azkar!).then((value) => customSnackBar(
//           context,
//           AppLocalizations.of(context)!.deletedZekrBookmark
//       ));
//       getAzkar();
//     } catch (e) {
//       print('Error deleting azkar: $e');
//       emit(AzkarError());
//     }
//   }

//   Future<void> updateAzkar(Azkar? azkar) async {
//     try {
//       print('Updating azkar: $azkar');
//       await DatabaseHelper.updateAzkar(azkar!);
//       getAzkar();
//     } catch (e) {
//       print('Error updating azkar: $e');
//       emit(AzkarError());
//     }
//   }

// }
