import 'package:flutter/foundation.dart' show ChangeNotifier, SynchronousFuture;
import 'package:flutter/widgets.dart' show BuildContext, RouterDelegate, Widget;

import '../../components/scaffold/scaffold.dart';
import 'path_match.dart';

class Router extends RouterDelegate<PathMatch> with ChangeNotifier {
  PathMatch _activeMatch = PathMatch.noMatch;
  PathMatch get match => _activeMatch;

  Router();

  @override
  PathMatch? get currentConfiguration => _activeMatch;

  @override
  Future<void> setNewRoutePath(PathMatch configuration) {
    _activeMatch = configuration;
    notifyListeners();
    return SynchronousFuture(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(_activeMatch);
  }

  @override
  Future<bool> popRoute() {
    final willPop = _activeMatch.canPop;
    if (willPop) {
      _activeMatch = _activeMatch.pop();
      notifyListeners();
    }
    return SynchronousFuture(willPop);
  }
}
