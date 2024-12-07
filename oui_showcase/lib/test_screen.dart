import 'package:oui/oui.dart';

class TestScreen extends OuiScreen {
  const TestScreen({
    super.key,
    this.id = 'test',
    this.iconData,
  });

  @override
  final String id;

  final IconData? iconData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text('This is the Test Screen'),
    );
  }
}
