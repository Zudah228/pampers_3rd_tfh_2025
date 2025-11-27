Future<List<T>> waitFuturesAndHoldOriginalOrder<T>(
  List<Future<T>> futures,
) async {
  final results = await Future.wait([
    for (final (index, future) in futures.indexed)
      Future(() async {
        return (index, await future);
      }),
  ]);

  return (results..sort(
        (a, b) => a.$1.compareTo(b.$1),
      ))
      .map((result) => result.$2)
      .toList();
}
