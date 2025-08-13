// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../bindings/azkary_binding.dart';

// // راوتر التطبيق لإدارة التنقل والمسارات
// // App router for navigation and routes management
// class AppRouter {
//   // المسارات / Routes
//   static const String home = '/home';
//   static const String azkar = '/azkar';
//   static const String quran_azkar = '/quran_azkar';
//   static const String books = '/books';
//   static const String settings = '/settings';
//   static const String reminders = '/reminders';

//   // صفحات GetX / GetX Pages
//   static List<GetPage> getPages() => [
//         GetPage(
//           name: home,
//           page: () => const HomePage(),
//           binding: AzkaryBinding(),
//         ),
//         GetPage(
//           name: azkar,
//           page: () => const AzkarPage(),
//           binding: AzkaryBinding(),
//         ),
//         GetPage(
//           name: quran_azkar,
//           page: () => const QuranAzkarPage(),
//           binding: AzkaryBinding(),
//         ),
//         GetPage(
//           name: books,
//           page: () => const BooksPage(),
//           binding: AzkaryBinding(),
//         ),
//         GetPage(
//           name: settings,
//           page: () => const SettingsPage(),
//           binding: AzkaryBinding(),
//         ),
//         GetPage(
//           name: reminders,
//           page: () => const RemindersPage(),
//           binding: AzkaryBinding(),
//         ),
//       ];
// }
