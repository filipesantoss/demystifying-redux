class Store<S> {
  final S Function(S?, dynamic) reducer;
  final _listeners = List<void Function()>.empty(growable: true);
  S? _state;

  Store(
    this.reducer, {
    S? initialState,
  }) : _state = initialState;

  void dispatch(dynamic action) {
    _state = reducer(_state, action);

    for (var element in _listeners) {
      element();
    }
  }

  void Function() subscribe(void Function() listener) {
    _listeners.add(listener);

    return () {
      _listeners.remove(listener);
    };
  }

  S? get state {
    return _state;
  }
}
