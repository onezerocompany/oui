import 'package:flutter/widgets.dart' as widgets show BoxFit;
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/components/box/box_fit.dart';

void main() {
  group('BoxFit', () {
    test('cover should have BoxFit.cover', () {
      expect(BoxFit.cover.boxFit, widgets.BoxFit.cover);
    });

    test('contain should have BoxFit.contain', () {
      expect(BoxFit.contain.boxFit, widgets.BoxFit.contain);
    });

    test('fill should have BoxFit.fill', () {
      expect(BoxFit.fill.boxFit, widgets.BoxFit.fill);
    });

    test('fitWidth should have BoxFit.fitWidth', () {
      expect(BoxFit.fitWidth.boxFit, widgets.BoxFit.fitWidth);
    });

    test('fitHeight should have BoxFit.fitHeight', () {
      expect(BoxFit.fitHeight.boxFit, widgets.BoxFit.fitHeight);
    });

    test('none should have BoxFit.none', () {
      expect(BoxFit.none.boxFit, widgets.BoxFit.none);
    });

    test('scaleDown should have BoxFit.scaleDown', () {
      expect(BoxFit.scaleDown.boxFit, widgets.BoxFit.scaleDown);
    });
  });
}
