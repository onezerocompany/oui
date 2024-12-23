typedef ConfigContainer<Key, Config> = Map<Key, Config>;

extension ConfigContainerExtension<Key, Config>
    on ConfigContainer<Key, Config> {
  Config? operator [](Key key) => this[key];
}
