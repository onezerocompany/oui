library oui;

export 'package:flutter/foundation.dart';
export 'package:flutter/widgets.dart';
export 'package:flutter_hooks/flutter_hooks.dart';
export 'package:hooks_riverpod/hooks_riverpod.dart'
    hide describeIdentity, shortHash;

// app
export 'src/app/oui_app.dart';

// components
export 'src/components/buttons/oui_pressable.dart';

// router
export 'src/router/oui_path_match.dart';
export 'src/router/oui_path_segment.dart';
export 'src/router/oui_path.dart';
export 'src/router/oui_route_information_parser.dart';
export 'src/router/oui_router_delegate.dart';

// scaffold
export 'src/scaffold/oui_scaffold.dart';

// screens
export 'src/screens/oui_screen.dart';

// theme
export 'src/theme/oui_theme.dart';

// utils
export 'src/utils/localized.dart';
