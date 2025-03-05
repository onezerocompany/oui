import 'package:flutter/widgets.dart'
    show
        BoxDecoration,
        Center,
        Column,
        CrossAxisAlignment,
        DecoratedBox,
        Decoration,
        Expanded,
        ListView,
        MainAxisAlignment,
        MainAxisSize,
        Widget;
import 'package:oui/oui.dart';

/// This enum is used to specify how a screen should be displayed within the
/// application's user interface. The different screen types provide flexibility
/// in presenting content based on the available space and user interaction requirements.
///
/// - `panel`: Displays the screen within the scaffold if there is enough space.
///   If the screen does not fit within the scaffold, it will be shown as a sheet.
///   This type is useful for adaptive layouts where the screen can dynamically
///   adjust its presentation based on the available space.
///
/// - `sheet`: Always shows the screen as a sheet overlaying the scaffold.
///   This type is ideal for presenting supplementary content that does not
///   require full-screen attention, such as forms or additional options.
///
/// - `modal`: Displays the screen as a modal dialog, which requires user interaction
///   before returning to the underlying content. This type is suitable for
///   critical actions or information that needs to be acknowledged by the user.
enum ScreenDisplayType {
  panel,
  sheet,
  modal;

  ScreenDisplayType demote() {
    switch (this) {
      case ScreenDisplayType.panel:
        return ScreenDisplayType.sheet;
      case ScreenDisplayType.sheet:
        return ScreenDisplayType.sheet;
      case ScreenDisplayType.modal:
        return ScreenDisplayType.modal;
    }
  }
}

/// Provider class for resolving metadata about OUI screens.
///
/// This class extends [Metadata] to include additional metadata information
/// specific to OUI screens, such as the path segments.
///
/// The [path] parameter is required and represents the path segments of the screen.
/// The [name] parameter is required and represents the localized name of the screen.
/// The [icon] parameter is optional and represents the localized icon data of the screen.
/// The [attributes] parameter is optional and represents a map of additional localized
/// attributes for the screen.
class ScreenMetadata extends Metadata {
  final Localized<Path> path;
  final ScreenDisplayType type;

  ScreenMetadata({
    required super.id,
    required super.name,
    required this.path,
    this.type = ScreenDisplayType.panel,
    super.icon,
    super.attributes,
    super.tags,
  });

  @override
  Metadata copyWith({
    String? id,
    Localized<String>? name,
    Localized<Icon?>? icon,
    Localized<List<String>>? tags,
    Localized<Map<String, dynamic>>? attributes,
    Localized<Path>? path,
    ScreenDisplayType? type,
  }) {
    return ScreenMetadata(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      tags: tags ?? this.tags,
      attributes: attributes ?? this.attributes,
      path: path ?? this.path,
      type: type ?? this.type,
    );
  }
}

class ScreenBoxContentModifier extends ComponentModifier {
  final ComponentWidgetBuilder? headerBuilder;
  final List<ConditionalComponent> sections;
  final ComponentWidgetBuilder? footerBuilder;

  const ScreenBoxContentModifier({
    this.headerBuilder,
    this.sections = const [],
    this.footerBuilder,
    super.condition,
  });

  @override
  ScreenBoxContentModifier merge(ComponentModifier other) {
    if (other is ScreenBoxContentModifier) {
      return ScreenBoxContentModifier(
        headerBuilder: headerBuilder ?? other.headerBuilder,
        sections: [...sections, ...other.sections],
        footerBuilder: footerBuilder ?? other.footerBuilder,
      );
    }
    return this;
  }
}

class ScreenBox extends BoxLike<ScreenBox> {
  const ScreenBox({
    super.key,
    super.modifiers,
  });

  factory ScreenBox.base() {
    return const ScreenBox(
      modifiers: [
        BackgroundModifier(auto: true),
        BorderModifier(Border.all(BorderSide(thickness: 1)), auto: true),
        CornerModifier(roundness: SizeLevel.medium),
      ],
    );
  }

  @override
  ScreenBox copyWith({ComponentModifiers? modifiers}) {
    return ScreenBox(
      key: key,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  ScreenBox header(
    ComponentWidgetBuilder builder, {
    ContextCondition? condition,
  }) {
    return withModifier(
      ScreenBoxContentModifier(
        headerBuilder: builder,
        condition: condition,
      ),
      stacks: true,
    );
  }

  ScreenBox footer(
    ComponentWidgetBuilder builder, {
    ContextCondition? condition,
  }) {
    return withModifier(
      ScreenBoxContentModifier(
        footerBuilder: builder,
        condition: condition,
      ),
      stacks: true,
    );
  }

  ScreenBox section(
    ComponentWidgetBuilder builder, {
    ContextCondition? condition,
  }) {
    return withModifier(
      ScreenBoxContentModifier(
        sections: [
          ConditionalComponent(
            builder: builder,
            condition: condition,
          ),
        ],
      ),
      stacks: true,
    );
  }

  @override
  Widget builder(ComponentContext context) {
    final provider = context.modifiers
        .whereType<ScreenBoxContentModifier>()
        .fold<ScreenBoxContentModifier?>(
          null,
          (
            ScreenBoxContentModifier? acc,
            ScreenBoxContentModifier provider,
          ) =>
              acc?.merge(provider) ?? provider,
        );

    final header = provider?.headerBuilder?.call(context);
    final footer = provider?.footerBuilder?.call(context);
    final sections = provider?.sections
            .where((section) => section.isAvailable(context))
            .toList() ??
        [];

    Widget widget = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (header != null) header,
        if (sections.isNotEmpty)
          Expanded(
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: sections.length,
                itemBuilder: (_, index) {
                  return sections[index].builder(context);
                },
              ),
            ),
          ),
        if (footer != null) footer,
      ],
    );

    widget = context.modifiers.whereType<ContentModifier>().fold(
      widget,
      (Widget acc, ContentModifier modifier) {
        return modifier.modify(acc, context) ?? acc;
      },
    );

    final decorators = context.modifiers.whereType<DecorationModifier>();
    if (decorators.isNotEmpty) {
      final Decoration decoration = decorators.fold(
        const BoxDecoration(),
        (Decoration acc, DecorationModifier decorator) =>
            decorator.decorate(acc, context) ?? acc,
      );
      widget = DecoratedBox(decoration: decoration, child: widget);
    }

    final hasBackground = context.modifiers.hasModifier<BackgroundModifier>();
    if (hasBackground) {
      widget = BoxLevelContext(
        level: BoxLevel.of(context.build).increase(1),
        child: widget,
      );
    }
    return widget;
  }
}

/// Represents a screen in the OUI framework.
abstract class Screen {
  const Screen();

  ScreenMetadata get metadata;

  // Routing properties
  bool available(DynamicContext context) => true;
  Uri? redirect(DynamicContext context) => null;

  Component content(ScreenBox screen);

  List<Screen> get children => const [];
}

typedef Screens = List<Screen>;
