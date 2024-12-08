import 'package:hive/hive.dart';

import '../../data/models/movie_list.dart';

class HiveService<T> {
  final String boxName;

  HiveService(this.boxName);

  Future<Box<T>> _openBox() async {
    return Hive.isBoxOpen(boxName)
        ? Hive.box<T>(boxName)
        : await Hive.openBox<T>(boxName);
  }

  Future<void> saveItem(dynamic key, T? item) async {
    if (item == null) return;
    final box = await _openBox();

    if (item is MovieList) {
      item.backdropPath = item.backdropPath.isEmpty ? '' : item.backdropPath;
      item.originalLanguage = item.originalLanguage.isEmpty ? '' : item.originalLanguage;
      item.originalTitle = item.originalTitle.isEmpty ? '' : item.originalTitle;
    }

    await box.put(key, item);
  }

  Future<T?> getItem(dynamic key) async {
    final box = await _openBox();
    return box.get(key.orEmpty());
  }

  Future<List<T>> getAllItems() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> deleteItem(dynamic key) async {
    final box = await _openBox();
    if (box.containsKey(key)) {
      await box.delete(key);
    }
  }

  Future<void> clearItems() async {
    final box = await _openBox();
    await box.clear();
  }

  Future<bool> containsKey(dynamic key) async {
    final box = await _openBox();
    return box.containsKey(key.orEmpty());
  }
}
