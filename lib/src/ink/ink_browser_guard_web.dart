import 'package:web/web.dart' as web;

/// Suppress browser-native pan/pinch only while the fixed drawing route is open.
/// Flutter scrolling in options/result panels and system text scaling still work.
class InkBrowserGuard {
  InkBrowserGuard() {
    final root = web.document.documentElement;
    if (root == null) return;
    _style = (root as web.HTMLElement).style;
    for (final entry in {
      'touch-action': 'none',
      'overscroll-behavior': 'none',
      'overflow': 'hidden',
    }.entries) {
      _previous[entry.key] = (
        _style!.getPropertyValue(entry.key),
        _style!.getPropertyPriority(entry.key),
      );
      _style!.setProperty(entry.key, entry.value);
    }
  }
  web.CSSStyleDeclaration? _style;
  final _previous = <String, (String, String)>{};

  void dispose() {
    for (final entry in _previous.entries) {
      if (entry.value.$1.isEmpty) {
        _style?.removeProperty(entry.key);
      } else {
        _style?.setProperty(entry.key, entry.value.$1, entry.value.$2);
      }
    }
    _previous.clear();
  }
}
