extension ListExtensions<T> on List<T?>? {
  bool get isNullOrEmpty {
    return this == null ||
        this!.isEmpty ||
        this!.every((element) => element == null);
  }

  bool get isNotNullOrEmpty {
    return !isNullOrEmpty;
  }
}
