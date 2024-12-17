import 'package:oui/oui.dart';

export 'oui_path.dart';
export 'oui_path_match.dart';

class OuiRouter extends RouterDelegate<OuiPathMatch> with ChangeNotifier {
  final OuiScreenRegistry _registry;

  OuiPathMatch _activeMatch = OuiPathMatch.noMatch;
  OuiPathMatch get match => _activeMatch;

  OuiRouter(this._registry);

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
