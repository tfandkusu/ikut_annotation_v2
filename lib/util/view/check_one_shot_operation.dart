void checkOneShotOperation<S, V>(S? previous, S next, V? Function(S) getValue,
    void Function(V) runOperation) {
  if (previous == null || getValue(previous) != getValue(next)) {
    final value = getValue(next);
    if (value != null) {
      runOperation(value);
    }
  }
}
