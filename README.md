A workaround for [Flutter Issue 108697](https://github.com/flutter/flutter/issues/108697)
that prevents state recovery on page refresh. Gets the state directly from the browser History API.

## Example

This app preserves the text on page refresh.

Runnable project: https://github.com/alexeyinkin/flutter-issue-108697-workaround/blob/main/example/main.dart

![Screen](https://raw.githubusercontent.com/alexeyinkin/flutter-issue-108697-workaround/main/example/example.gif)

## Usage

Add this code to your `RouteInformationParser`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_issue_108697_workaround/flutter_issue_108697_workaround.dart'; // ADDED

class MyRouteInformationParser extends RouteInformationParser {
  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) async {
    routeInformation = apply108697Workaround(routeInformation);                        // ADDED
    // ... continue your parsing.
  }
  // ...
}
```

The method is deliberately named awkward so you periodically stumble onto it while reading your
code and check if the issue is fixed in Flutter yet so you can remove this workaround later.

## The Workaround

If not in web, does nothing.

In web, if `RouteInformation.state` is not null, does nothing.

Otherwise, checks the state directly with the browser's History API like this:

```dart
final stateJson = js.context.callMethod(
  'eval',
  ['JSON.stringify(history.state.state)'],
);

return RouteInformation(
  location: routeInformation.location,
  state: jsonDecode(stateJson),
);
```
