import 'package:oui/oui.dart';

class OuiScaffold extends HookConsumerWidget {
  final OuiPathMatch currentPath;

  const OuiScaffold(
    this.currentPath, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // color: context.ouiTheme.backdropColor,
      child: Column(
        children: [
          Text(currentPath.toString()),
          Stack(
            children: [
              for (var screen in currentPath.screens)
                screen.build(context, ref),
            ],
          ),
        ],
      ),
    );
  }
}
