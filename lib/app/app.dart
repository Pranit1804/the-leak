import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'theme.dart';

class TheLeakApp extends StatelessWidget {
  const TheLeakApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'The Leak',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: router,
      builder: (context, child) {
        // Respect system text scaling up to 1.3× (docs/DESIGN.md section 8).
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: media.textScaler.clamp(maxScaleFactor: 1.3)),
          child: child!,
        );
      },
    );
  }
}
