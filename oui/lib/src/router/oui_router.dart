import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'oui_path_match.dart';
import '../scaffold/oui_scaffold.dart';

class OuiRouter extends RouterDelegate<OuiPathMatch> with ChangeNotifier {
  OuiPathMatch _activeMatch = OuiPathMatch.noMatch;
  OuiPathMatch get match => _activeMatch;

  OuiRouter();

  @override
  OuiPathMatch? get currentConfiguration => _activeMatch;

  @override
  Future<void> setNewRoutePath(OuiPathMatch configuration) {
    _activeMatch = configuration;
    notifyListeners();
    return SynchronousFuture(null);
  }

  @override
  Widget build(BuildContext context) {
    return OuiScaffold(_activeMatch);
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
