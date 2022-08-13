import 'dart:convert';
import 'dart:js' as js; // ignore: avoid_web_libraries_in_flutter

import 'package:flutter/widgets.dart';

/// A web implementation that gets the state directly with the browser's
/// History API if it finds a `null` state reported by Flutter.
RouteInformation apply108697Workaround(RouteInformation routeInformation) {
  if (routeInformation.state != null) {
    return routeInformation;
  }

  final stateJson = js.context.callMethod(
    'eval',
    ['JSON.stringify(history.state.state)'],
  );

  return RouteInformation(
    location: routeInformation.location,
    state: jsonDecode(stateJson),
  );
}
