import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_social_app/theme/palette.dart';

class AppSettingsPage extends ConsumerWidget {
  const AppSettingsPage({super.key});
  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () => toggleTheme(ref),
              child: const Text('Change theme'))
        ],
      ),
    );
  }
}
