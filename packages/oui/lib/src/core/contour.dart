import 'package:contour/contour.dart';
import 'package:flutter/widgets.dart'
    show BuildContext, State, StatefulWidget, Widget;

// TODO: finish the contour builder

class ContourBuilder extends StatefulWidget {
  final VariableInstance instance;
  final Widget Function(BuildContext, VariableInstance) builder;

  const ContourBuilder({
    super.key,
    required this.instance,
    required this.builder,
  });

  @override
  State<ContourBuilder> createState() => _ContourBuilderState();
}

class _ContourBuilderState extends State<ContourBuilder> {
  Subscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = widget.instance.subscribe(
      (_) => _update,
    );
  }

  void _update() {
    setState(() {});
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.instance);
  }
}
