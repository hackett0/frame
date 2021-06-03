import 'package:flutter/cupertino.dart';

mixin StateMixin<T> extends T {
}

class State<T> with StateMixin<T> {
  final T value;

  State(this.value);

  T operator() => value;
}

void test() {
  State<int> s = State<int>(1);
  int a = s;
}
