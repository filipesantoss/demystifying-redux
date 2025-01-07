import 'package:redux/redux.dart';

enum Action {
  feed,
  play,
  sleep,
}

class Tamagotchi {
  final int hunger;
  final int happiness;
  final bool sleeping;

  Tamagotchi({
    this.hunger = 50,
    this.happiness = 50,
    this.sleeping = false,
  });

  @override
  String toString() {
    return '{ hunger: $hunger, happiness: $happiness, sleeping: $sleeping }';
  }
}

Tamagotchi reducer(Tamagotchi? state, dynamic action) {
  final value = state ?? Tamagotchi();

  if (action is! Action) {
    return value;
  }

  int asPercent(int number) {
    return number.clamp(0, 100);
  }

  switch (action) {
    case Action.feed:
      return value.sleeping
          ? value
          : Tamagotchi(
              hunger: asPercent(value.hunger - 20),
              happiness: value.happiness,
              sleeping: value.sleeping,
            );

    case Action.play:
      return value.sleeping
          ? value
          : Tamagotchi(
              hunger: value.hunger,
              happiness: asPercent(value.happiness + 20),
              sleeping: value.sleeping,
            );

    case Action.sleep:
      return Tamagotchi(
        hunger: value.hunger,
        happiness: value.happiness,
        sleeping: true,
      );

    default:
      return value;
  }
}

void main() {
  final store = Store(reducer);

  final unsubscribe = store.subscribe(() {
    print('SUBSCRIBER 01: ${store.state}');
  });

  store.subscribe(() {
    print('SUBSCRIBER 02: ${store.state}');
  });

  store.dispatch(Action.feed);
  store.dispatch(Action.play);
  store.dispatch(Action.feed);
  unsubscribe();
  store.dispatch(Action.feed);
  store.dispatch(Action.play);
  store.dispatch(Action.sleep);
  store.dispatch(Action.play);
}
