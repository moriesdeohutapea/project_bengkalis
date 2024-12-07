extension StringNullSafe on String? {
  String orEmpty() {
    return this ?? '';
  }
}

extension IntNullSafe on int? {
  int orZero() {
    return this ?? 0;
  }
}

extension DoubleNullSafe on double? {
  double orZero() {
    return this ?? 0.0;
  }
}

extension BoolNullSafe on bool? {
  bool orFalse() {
    return this ?? false;
  }
}

extension ListNullSafe<T> on List<T>? {
  List<T> orEmpty() {
    return this ?? [];
  }
}

extension SetNullSafe<T> on Set<T>? {
  Set<T> orEmpty() {
    return this ?? {};
  }
}

extension MapNullSafe<K, V> on Map<K, V>? {
  Map<K, V> orEmpty() {
    return this ?? {};
  }
}

extension DateTimeNullSafe on DateTime? {
  DateTime orNow() {
    return this ?? DateTime.now();
  }
}

extension FutureNullSafe<T> on Future<T>? {
  Future<T> orCompleted(T defaultValue) {
    return this ?? Future.value(defaultValue);
  }
}
