// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../model/books_model.dart';
// import '../fetchBooks.dart';

// part 'books_state.dart';

// class BooksCubit extends Cubit<BooksState> {
//   BooksCubit() : super(ClassesLoading()) {
//     getClasses();
//   }
//   static BooksCubit get(context) => BlocProvider.of<BooksCubit>(context);

//   PageController? pageController;
//   final int numPages = 3; // The number of pages
//   int currentPage = 0;


//   Future<List<Class>> getClasses() async {
//     // Emit loading state
//     emit(ClassesLoading());

//     try {
//       // Fetch classes
//       final classes = await fetchClasses();

//       // Emit loaded state
//       emit(ClassesLoaded(classes));

//       // Return the fetched classes
//       return classes;
//     } catch (e, s) {
//       print('Exception details:\n $e');
//       print('Stack trace:\n $s');
//       emit(ClassesError(e));

//       // In case of error, throw the exception
//       throw e;
//     }
//   }


//   void selectClass(Class selectedClass) {
//     emit(ClassSelected(selectedClass));
//   }
// }