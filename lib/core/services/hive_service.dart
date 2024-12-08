import 'package:hive/hive.dart';
import 'package:project_bengkalis/data/models/movie_list.dart';

/// HiveService untuk operasi CRUD
class HiveService<T> {
  final String boxName;

  HiveService(this.boxName);

  /// Membuka atau mendapatkan Hive box
  Future<Box<T>> _openBox() async {
    return Hive.isBoxOpen(boxName)
        ? Hive.box<T>(boxName)
        : await Hive.openBox<T>(boxName);
  }

  /// Menyimpan atau memperbarui item di Hive
  Future<void> saveItem(dynamic key, T? item) async {
    if (item == null) return;
    final box = await _openBox();
    await box.put(key.orEmpty(), item);
  }

  /// Mendapatkan item berdasarkan key
  Future<T?> getItem(dynamic key) async {
    final box = await _openBox();
    return box.get(key.orEmpty());
  }

  /// Mendapatkan semua item
  Future<List<T>> getAllItems() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Menghapus item berdasarkan key
  Future<void> deleteItem(dynamic key) async {
    final box = await _openBox();
    await box.delete(key.orEmpty());
  }

  /// Menghapus semua item dari Hive box
  Future<void> clearItems() async {
    final box = await _openBox();
    await box.clear();
  }

  /// Mengecek apakah item ada berdasarkan key
  Future<bool> containsKey(dynamic key) async {
    final box = await _openBox();
    return box.containsKey(key.orEmpty());
  }
}
