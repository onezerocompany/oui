import 'package:contour/src/listenable.dart';
import 'package:test/test.dart';

void main() {
  group('Listenable', () {
    test('should allow subscribing and notifying subscribers', () {
      final listenable = Listenable<String>();
      String? notifiedValue;
      listenable.subscribe((value) {
        notifiedValue = value;
      });
      listenable.notifySubscribers('test');
      expect(notifiedValue, 'test');
    });

    test('should allow cancelling subscriptions', () {
      final listenable = Listenable<String>();
      String? notifiedValue;
      final subscription = listenable.subscribe((value) {
        notifiedValue = value;
      });
      subscription.cancel();
      listenable.notifySubscribers('test');
      expect(notifiedValue, isNull);
    });
  });
}
