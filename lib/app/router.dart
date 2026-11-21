import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/widgets/screen_scaffold.dart';

/// Routes from docs/TECH_SPEC.md section 7, plus edit, settings and licences.
abstract final class Routes {
  static const home = '/';
  static const newTrip = '/trip/new';
  static String editTrip(int tripId) => '/trip/$tripId/edit';
  static String newRound(int tripId) => '/trip/$tripId/round/new';
  static String round(int roundId) => '/round/$roundId';
  static String standings(int tripId) => '/trip/$tripId/standings';
  static String wrapped(int tripId) => '/trip/$tripId/wrapped';
  static const settings = '/settings';
  static const licences = '/licences';
}

int _id(GoRouterState s, String name) => int.parse(s.pathParameters[name]!);

GoRouter buildRouter({String initialLocation = Routes.home}) => GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: Routes.home, builder: (c, s) => const _Placeholder('HOME')),
        GoRoute(path: Routes.newTrip, builder: (c, s) => const _Placeholder('NEW TRIP')),
        GoRoute(path: '/trip/:tripId/edit', builder: (c, s) => _Placeholder('EDIT ${_id(s, 'tripId')}')),
        GoRoute(path: '/trip/:tripId/round/new', builder: (c, s) => _Placeholder('ROUND SETUP ${_id(s, 'tripId')}')),
        GoRoute(path: '/round/:roundId', builder: (c, s) => _Placeholder('ROUND ${_id(s, 'roundId')}')),
        GoRoute(path: '/trip/:tripId/standings', builder: (c, s) => _Placeholder('STANDINGS ${_id(s, 'tripId')}')),
        GoRoute(path: '/trip/:tripId/wrapped', builder: (c, s) => _Placeholder('WRAPPED ${_id(s, 'tripId')}')),
        GoRoute(path: Routes.settings, builder: (c, s) => const _Placeholder('SETTINGS')),
        GoRoute(path: Routes.licences, builder: (c, s) => const _Placeholder('LICENCES')),
      ],
    );

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => PaperScreen(children: [Headline(title)]);
}
