import 'package:fue/fue.dart';

class FirebaseConfig {
  final FirebaseOptions options;

  const FirebaseConfig({required this.options});
}

class FueConfig extends Config {
  final FirebaseConfig firebase;

  @override
  buildAuthProvider() {
    return FirebaseAuthProvider();
  }

  FueConfig({
    required super.details,
    required super.registry,
    required this.firebase,
    super.colors = const ColorConfig(),
    super.scaffold = const ScaffoldConfig(),
    super.screens = const ScreenConfig(),
    super.typography = const TypographyConfig(),
    super.responsive = const ResponsiveConfig(),
    super.locales = const [Locale.en],
  });
}
