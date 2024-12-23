import 'package:flutter/widgets.dart';
import 'package:oui/oui.dart';
import '../box/oui_box_side.dart';

class OuiRail extends OuiBox {
  final OuiBoxSide side;

  @override
  OuiBorder? get border {
    final opposite = side.opposite;
    return OuiBorder.forBoxSide(
      opposite,
      OuiBorderSide.none,
    );
  }

  const OuiRail(
    this.side, {
    super.key,
  });
}

class OuiRailedContainer extends StatelessWidget {
  final Widget child;

  const OuiRailedContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OuiRail(OuiBoxSide.left),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const OuiRail(OuiBoxSide.top),
              Flexible(
                child: child,
              ),
              const OuiRail(OuiBoxSide.bottom),
            ],
          ),
        ),
        const OuiRail(OuiBoxSide.right),
      ],
    );
  }
}
