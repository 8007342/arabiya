import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.onSignedIn});
  final Future<void> Function() onSignedIn;

  @override
  Widget build(BuildContext context) => const Text(
    'Google sign-in is available in the web app.',
    style: TextStyle(fontSize: 24),
  );
}
