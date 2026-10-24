import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

@JS('arabiyaRenderGoogleButton')
external void _renderButton(web.Element element, JSFunction callback);

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key, required this.onSignedIn});
  final Future<void> Function() onSignedIn;

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  String? _error;
  bool _busy = false;
  int _attempt = 0;

  Future<void> _complete(String error) async {
    if (!mounted) return;
    if (error.isNotEmpty) {
      setState(() => _error = error);
      return;
    }
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onSignedIn();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Could not restore your cloud save. Please retry.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (_error == null && !_busy)
        SizedBox(
          height: 56,
          width: 280,
          child: HtmlElementView.fromTagName(
            key: ValueKey(_attempt),
            tagName: 'div',
            onElementCreated: (element) {
              // The platform element is attached after this frame.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _renderButton(
                    element as web.Element,
                    ((JSString message) {
                      _complete(message.toDart);
                    }).toJS,
                  );
                }
              });
            },
          ),
        ),
      if (_busy)
        const Text('Restoring your save…', style: TextStyle(fontSize: 24)),
      if (_error != null) ...[
        Text(_error!, style: const TextStyle(fontSize: 24)),
        TextButton(
          onPressed: () => setState(() {
            _error = null;
            _attempt++;
          }),
          child: const Text(
            'Retry Google sign-in',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    ],
  );
}
