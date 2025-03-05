import 'package:contour/contour.dart';

class DataManagerScope {
  const DataManagerScope._(
    this.global,
    this.screen,
    this.box,
  );

  const DataManagerScope.global() : this._(true, null, null);
  const DataManagerScope.screen(String screen) : this._(false, screen, null);
  const DataManagerScope.box(String screen, String box)
      : this._(false, screen, box);

  final bool global;
  final String? screen;
  final String? box;
}

class DataManager {
  DataManager();

  final instances = <DataManagerScope, Map<String, VariableInstance>>{};

  void register(
    DataManagerScope scope,
    String name,
    ContourType schema,
  ) {
    instances.putIfAbsent(scope, () => {})[name] = schema.instance(name);
  }

  VariableInstance? get(DataManagerScope scope, String name) {
    return instances[scope]?[name];
  }
}
