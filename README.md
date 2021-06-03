# frame

A set of utilities that allow you to easily pass a data Model from a parent Widget down to it's descendants.

This Library provides two main classes:

  * The `Provider` Widget. If you need to pass a `Store` deep down your Widget hierarchy, you can wrap your `Store` in a `Provider` Widget. This will make the Model available to all descendant Widgets.
  * The `StateWidget` Widget. Use this Widget to find the appropriate `Store` in the Widget tree. It will automatically rebuild whenever the Model notifies that change has taken place.

## Examples

  * [Counter App](https://github.com/hackett0/flutter_frame/blob/master/test/example.dart) - Introduction to the tools provided by frame. 

## Usage

Let's demo the basic usage with the all-time favorite: A counter example!

```dart
class Counter extends ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }
}

class Store {
  final counter = Counter();
}

main() => runApp(Provider(
      store: Store(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frame Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frame Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            StateWidget(
              state: (store) => store.counter,
              builder: (context, child, counter) => Text(
                '${counter.value.toString()}',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            StateWidget.of(context, (store) => store.counter).increment(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

```

## Contributors

  * [Hackett](https://github.com/hackett0)
