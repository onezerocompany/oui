import 'package:oui/oui.dart';

class AppDetails extends Metadata {
  final String version;

  const AppDetails({
    required super.name,
    super.icon,
    super.attributes,
    required this.version,
  });
}
