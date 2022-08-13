import 'package:flutter/material.dart';
import 'package:flutter_issue_108697_workaround/flutter_issue_108697_workaround.dart';

void main() => runApp(MyApp());

final _controller = TextEditingController();

class Configuration {
  final String? location;
  final Object? state;

  Configuration(this.location, this.state);

  @override
  toString() => '$location $state';
}

class MyRouterDelegate extends RouterDelegate<Configuration>
    with ChangeNotifier {
  MyRouterDelegate() {
    _controller.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('This field is preserved on page refresh')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(controller: _controller),
        ),
      ),
    );
  }

  @override
  Future<bool> popRoute() async => true;

  @override
  Future<void> setNewRoutePath(configuration) async {
    final state = configuration.state;
    if (state is! Map) return;
    _controller.text = state['text'] ?? '';
    notifyListeners();
  }

  @override
  Configuration get currentConfiguration {
    return Configuration('/', {'text': _controller.text});
  }
}

final delegate = MyRouterDelegate();

class MyRouteInformationParser extends RouteInformationParser<Configuration> {
  @override
  Future<Configuration> parseRouteInformation(RouteInformation ri) async {
    ri = apply108697Workaround(ri); // Remove this line, and text is lost.
    return Configuration(ri.location, ri.state);
  }

  @override
  RouteInformation restoreRouteInformation(Configuration configuration) {
    return RouteInformation(
      location: configuration.location,
      state: configuration.state,
    );
  }
}

final parser = MyRouteInformationParser();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: delegate,
      routeInformationParser: parser,
      debugShowCheckedModeBanner: false,
    );
  }
}
