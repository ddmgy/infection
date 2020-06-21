import 'dart:math' as Math;

extension ListExtensions<T> on List<T> {
  int maxBy(int get(T element)) {
    if (this.length == 0) {
      return null;
    }
    int result = get(this[0]);
    this.forEach((T e) {
      int test = get(e);
      result = Math.max(result, test);
    });
    return result;
  }
}