import 'package:oui/oui.dart';

class OuiRouterDelegate extends RouterDelegate<OuiPathMatch>
    with ChangeNotifier {
  OuiPathMatch _currentPath = OuiPathMatch.noMatch;

  @override
  Future<void> setNewRoutePath(configuration) {
    _currentPath = configuration;
    notifyListeners();
    return SynchronousFuture(null);
  }

  @override
  Widget build(BuildContext context) {
    return OuiScaffold(_currentPath);
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }
}
