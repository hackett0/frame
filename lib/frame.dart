import 'package:flutter/widgets.dart';

class Provider<T> extends StatefulWidget {
  const Provider({Key? key, required this.child, required this.store}) : super(key: key);
  final Widget child;
  final T store;

  @override
  _ProviderState createState() => _ProviderState<T>();
}

class _ProviderState<T> extends State<Provider> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedWidget(key: widget.key, value: widget.store, child: widget.child);
}

class _InheritedWidget<T> extends InheritedWidget {
  final T value;

  _InheritedWidget({Key? key, required this.value, required Widget child}) : super(key: key, child: child);

  static _InheritedWidget? of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<_InheritedWidget>()?.widget;
    return widget is _InheritedWidget ? widget : null;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}

typedef WidgetBuilder<M> = Widget Function(BuildContext context, Widget child, M state);
typedef StateBuilder<T, M> = M Function(T);

///-
class StateWidget<T, M> extends StatelessWidget {
  final WidgetBuilder<M> builder;
  final StateBuilder<T, M> state;
  final Widget child;

  const StateWidget({Key? key, required this.builder, required this.state, required this.child});

  @override
  Widget build(BuildContext context) {
    final model = StateWidget.of(context, state);

    return (model is Listenable)
        ? _StateHandleWidget(child: child, state: model, builder: builder, listenable: model, key: key)
        : builder(context, child, model);
  }

  static M of<T, M>(BuildContext context, StateBuilder<T, M> state) {
    final widget = _InheritedWidget.of(context)!;
    return state(widget.value);
  }
}

class _StateHandleWidget<M> extends StatefulWidget {
  const _StateHandleWidget({Key? key, required this.state, required this.listenable, required this.builder, required this.child}) : super(key: key);

  final Listenable listenable;
  final WidgetBuilder<M> builder;
  final Object state;
  final Widget child;

  @override
  _StateHandleWidgetState createState() => _StateHandleWidgetState();
}

class _StateHandleWidgetState extends State<_StateHandleWidget> {
  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(handleChange);
  }

  @override
  void didUpdateWidget(_StateHandleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(handleChange);
      widget.listenable.addListener(handleChange);
    }
  }

  @override
  void dispose() {
    widget.listenable.removeListener(handleChange);
    super.dispose();
  }

  void handleChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.child, widget.state);
}
