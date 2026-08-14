part of '../books.dart';

/// غلاف شاشة كاملة لعرض BooksPage بدلاً من الـ modal bottom sheet
class BookPageScreen extends StatelessWidget {
  final BooksPage child;
  const BookPageScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(child: child),
      ),
    );
  }
}
