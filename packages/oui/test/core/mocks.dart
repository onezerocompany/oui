import 'package:flutter/src/widgets/framework.dart';
import 'package:oui/oui.dart';

class MockScreen implements Screen {
  MockScreen({
    required this.name,
    this.childScreens = const [],
    this.pathSegments = const [],
    this.shouldBeAvailable = true,
    this.redirectUri,
  });

  final String name;
  final List<Screen> childScreens;
  final List<PathSegment> pathSegments;
  final bool shouldBeAvailable;
  final Uri? redirectUri;

  @override
  List<Screen> get children => childScreens;

  @override
  bool available(ComponentContext context) => shouldBeAvailable;

  @override
  Uri? redirect(ComponentContext context) => redirectUri;

  @override
  ScreenMetadata get metadata {
    return ScreenMetadata(
      id: name,
      name: {Locale.any: name},
      path: {Locale.any: Path.fromString('/$name')},
    );
  }

  @override
  Component<Widget> build(ScreenBox content) {
    return content;
  }
}
