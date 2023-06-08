import 'dart:convert';
import 'dart:js' as js; // ignore: avoid_web_libraries_in_flutter

import 'package:flutter/widgets.dart';

/// A web implementation that gets the state directly with the browser's
/// History API if it finds a `null` state reported by Flutter.
RouteInformation apply108697Workaround(RouteInformation routeInformation) {
  if (routeInformation.state != null) {
    return routeInformation;
  }

  try {
    final stateJson = js.context.callMethod(
      'eval',
      ['JSON.stringify(history.state.state)'],
    );

    return RouteInformation(
      location: routeInformation.location,
      state: jsonDecode(stateJson),
    );

    // ignore: avoid_catches_without_on_clauses
  } catch (ex) {
    // In Gnome Web, and probably other WebKit browsers, we get
    // NoSuchMethodError: method not found: 'state' on null
    return routeInformation;
  }
}
