import 'dart:developer';

import 'package:get_storage/get_storage.dart';

import '../presentation/screens/azkar/azkar.dart';

/// DatabaseHelper — طبقة تخزين المفضلة فوق GetStorage
/// Favorites storage layer backed by GetStorage
///
/// استُبدلت sqflite بـ GetStorage لتبسيط التخزين وإزالة اعتماد Android SDK.
/// الحافظة: مفتاح واحد 'azkar_favorites' يحوي قائمة من خرائط Azkar.toJson().
/// Replaced sqflite with GetStorage to simplify storage and remove the
/// Android SDK dependency. Backed by a single 'azkar_favorites' key holding a
/// list of Azkar.toJson() maps.
class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static final GetStorage _box = GetStorage();

  // أسماء الأعمدة محفوظة للتوافق مع الاستدعاءات / Column names kept for compat
  static const String tableAzkar = 'azkarTable';
  static const String columnDescription = 'description';
  static const String columnAId = 'id';

  // مفتاح التخزين / Storage key
  static const String _storageKey = 'azkar_favorites';

  /// قراءة كل المفضلة كقائمة خرائط / Read all favorites as a list of maps
  static List<Map<String, dynamic>> _readAll() {
    final List<dynamic> raw = _box.read<List<dynamic>>(_storageKey) ?? [];
    return raw.cast<Map<String, dynamic>>();
  }

  /// كتابة كامل قائمة المفضلة / Write the entire favorites list
  static Future<void> _writeAll(List<Map<String, dynamic>> list) async {
    await _box.write(_storageKey, list);
  }

  /// إضافة ذكر إلى المفضلة - يُرجع الصف الجديد أو -1 عند الفشل
  /// Add azkar to favorites - returns the new row id, or -1 on failure
  static Future<int> addAzkar(Azkar? azkar) async {
    try {
      final list = _readAll();
      // توليد معرّف جديد (أكبر معرّف + 1، أو 0 إن كانت فارغة)
      // Generate new id (max id + 1, or 0 if empty)
      final newId = list.isEmpty
          ? 0
          : (list.map((e) => (e['id'] as num?)?.toInt() ?? 0).fold<int>(
                  0, (a, b) => a > b ? a : b) +
              1);
      final map = azkar!.toJson();
      map['id'] = newId;
      list.add(map);
      await _writeAll(list);
      log('Added azkar id=$newId', name: 'DatabaseHelper');
      return newId;
    } catch (e) {
      log('Error saving azkar: $e', name: 'DatabaseHelper');
      return -1;
    }
  }

  /// حذف ذكر بالمعرّف / Delete azkar by id
  static Future<int> deleteAzkar(Azkar? azkar) async {
    try {
      final list = _readAll();
      final initialLen = list.length;
      list.removeWhere((e) => e['id'] == azkar!.id);
      await _writeAll(list);
      final removed = initialLen - list.length;
      log('Deleted azkar id=${azkar!.id} ($removed row)', name: 'DatabaseHelper');
      return removed;
    } catch (e) {
      log('Error deleting azkar: $e', name: 'DatabaseHelper');
      return 0;
    }
  }

  /// تحديث ذكر بالمعرّف / Update azkar by id
  static Future<int> updateAzkar(Azkar azkar) async {
    try {
      final list = _readAll();
      int updated = 0;
      for (int i = 0; i < list.length; i++) {
        if (list[i]['id'] == azkar.id) {
          list[i] = azkar.toJson();
          updated++;
        }
      }
      await _writeAll(list);
      log('Updated azkar id=${azkar.id} ($updated row)', name: 'DatabaseHelper');
      return updated;
    } catch (e) {
      log('Error updating azkar: $e', name: 'DatabaseHelper');
      return 0;
    }
  }

  /// جلب كل المفضلة / Query all favorites
  static Future<List<Map<String, dynamic>>> queryC() async {
    log('Query favorites', name: 'DatabaseHelper');
    return _readAll();
  }
}
