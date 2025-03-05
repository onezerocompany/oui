// lib/src/listenable.dart

class Listenable<T> {
  final List<Subscription<T>> _subscriptions = [];
  Listenable();

  Subscription<T> subscribe(void Function(T? value) callback) {
    final subscription = Subscription<T>(this, callback);
    _subscriptions.add(subscription);
    return subscription;
  }

  void _removeSubscription(Subscription<T> subscription) {
    _subscriptions.remove(subscription);
  }

  void notifySubscribers(T? value) {
    for (final sub in List<Subscription<T>>.from(_subscriptions)) {
      sub.callback(value);
    }
  }
}

class Subscription<T> {
  final Listenable<T> listenable;
  final void Function(T? value) callback;

  Subscription(this.listenable, this.callback);

  void cancel() {
    listenable._removeSubscription(this);
  }
}
