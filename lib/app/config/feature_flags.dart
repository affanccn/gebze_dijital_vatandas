class FeatureFlags {
  final Map<String, bool> _overrides;

  const FeatureFlags([this._overrides = const {}]);

  const FeatureFlags.allEnabled() : _overrides = const {};

  bool isEnabled(String key) {
    return _overrides[key] ?? true;
  }
}
