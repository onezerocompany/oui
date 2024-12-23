import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oui/src/components/box/oui_box_fit.dart';

void main() {
  group('OuiBoxFit', () {
    test('cover should have BoxFit.cover', () {
      expect(OuiBoxFit.cover.boxFit, BoxFit.cover);
    });

    test('contain should have BoxFit.contain', () {
      expect(OuiBoxFit.contain.boxFit, BoxFit.contain);
    });

    test('fill should have BoxFit.fill', () {
      expect(OuiBoxFit.fill.boxFit, BoxFit.fill);
    });

    test('fitWidth should have BoxFit.fitWidth', () {
      expect(OuiBoxFit.fitWidth.boxFit, BoxFit.fitWidth);
    });

    test('fitHeight should have BoxFit.fitHeight', () {
      expect(OuiBoxFit.fitHeight.boxFit, BoxFit.fitHeight);
    });

    test('none should have BoxFit.none', () {
      expect(OuiBoxFit.none.boxFit, BoxFit.none);
    });

    test('scaleDown should have BoxFit.scaleDown', () {
      expect(OuiBoxFit.scaleDown.boxFit, BoxFit.scaleDown);
    });
  });
}
