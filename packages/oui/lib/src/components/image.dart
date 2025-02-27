import 'dart:typed_data' show Uint8List;

import 'package:flutter/widgets.dart'
    show BlendMode, ColorFilter, SizedBox, Widget;
import 'package:flutter/widgets.dart' as widgets show Image;
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

import '../core/colors.dart' show Color;
import '../core/component.dart'
    show Component, ComponentContext, ComponentModifier, ComponentModifiers;
import '../core/geometry.dart' show ModifiableSize;
import 'box.dart' show ContentModifier;

enum ImageType { svg, image }

class ImageProviderModifier extends ComponentModifier {
  final ImageType type;
  final String? path;
  final String? url;
  final Uint8List? bytes;

  const ImageProviderModifier({
    required this.type,
    this.path,
    this.url,
    this.bytes,
    super.condition,
  });

  Widget? provide(ComponentContext context) {
    final color = context.modifiers
        .whereType<ColorFilterModifier>()
        .firstOrNull
        ?.provide(context);

    if (type == ImageType.svg) {
      final filter = color != null
          ? ColorFilter.mode(color.uiColor, BlendMode.srcIn)
          : null;
      if (path != null) {
        return SvgPicture.asset(
          path!,
          colorFilter: filter,
        );
      } else if (url != null) {
        return SvgPicture.network(
          url!,
          colorFilter: filter,
        );
      } else if (bytes != null) {
        return SvgPicture.memory(
          bytes!,
          colorFilter: filter,
        );
      }
    } else {
      if (path != null) {
        return widgets.Image.asset(
          path!,
          color: color?.uiColor,
        );
      } else if (url != null) {
        return widgets.Image.network(
          url!,
          color: color?.uiColor,
        );
      } else if (bytes != null) {
        return widgets.Image.memory(
          bytes!,
          color: color?.uiColor,
        );
      }
    }
    return null;
  }

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is ImageProviderModifier) {
      return ImageProviderModifier(
        type: other.type,
        path: other.path ?? path,
        url: other.url ?? url,
        bytes: other.bytes ?? bytes,
      );
    }
    return this;
  }
}

typedef ColorBuilder = Color Function(ComponentContext context);

class ColorFilterModifier extends ComponentModifier {
  final Color? color;
  final ColorBuilder? colorBuilder;

  const ColorFilterModifier({
    this.color,
    this.colorBuilder,
    super.condition,
  });

  @override
  ComponentModifier merge(ComponentModifier other) {
    if (other is ColorFilterModifier) {
      return ColorFilterModifier(
        color: other.color ?? color,
        colorBuilder: other.colorBuilder ?? colorBuilder,
      );
    }
    return this;
  }

  Color? provide(ComponentContext context) {
    return colorBuilder?.call(context) ?? color;
  }
}

class Image extends Component<Image> with ModifiableSize<Image> {
  const Image({
    super.key,
    super.modifiers,
  });

  @override
  Image copyWith({ComponentModifiers? modifiers}) {
    return Image(
      key: key,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  @override
  Widget builder(ComponentContext context) {
    Widget image = context.modifiers
            .whereType<ImageProviderModifier>()
            .firstOrNull
            ?.provide(context) ??
        const SizedBox.shrink();

    image = context.modifiers.whereType<ContentModifier>().fold(
      image,
      (Widget acc, ContentModifier modifier) {
        return modifier.modify(acc, context) ?? acc;
      },
    );

    return image;
  }

  Image svg({
    String? path,
    String? url,
    Uint8List? bytes,
  }) =>
      withModifier(
        ImageProviderModifier(
          type: ImageType.svg,
          path: path,
          url: url,
          bytes: bytes,
        ),
      );

  Image image({
    String? path,
    String? url,
    Uint8List? bytes,
  }) =>
      withModifier(
        ImageProviderModifier(
          type: ImageType.image,
          path: path,
          url: url,
          bytes: bytes,
        ),
      );

  Image color(Color color) {
    return withModifier(
      ColorFilterModifier(color: color),
    );
  }

  Image colorBuilder(ColorBuilder colorBuilder) {
    return withModifier(
      ColorFilterModifier(
        colorBuilder: colorBuilder,
      ),
    );
  }
}
