library oui;

export 'package:flutter/foundation.dart';
export 'package:flutter/widgets.dart';
export 'package:flutter_hooks/flutter_hooks.dart';
export 'package:hooks_riverpod/hooks_riverpod.dart'
    hide describeIdentity, shortHash;

// actions
export 'src/actions/oui_action.dart';

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
export 'src/scaffold/oui_scaffold_rail.dart';

// screens
export 'src/screens/oui_screen.dart';

// theme
export 'src/config/oui_config.dart';

// providers
export 'src/providers/oui_auth_provider.dart';
export 'src/providers/oui_metadata_provider.dart';

// utils
export 'src/utils/localized.dart';
export 'src/utils/oui_sides.dart';
export 'src/utils/oui_border.dart';
export 'src/utils/range.dart';
export 'src/utils/background.dart';
export 'src/utils/config_container.dart';
