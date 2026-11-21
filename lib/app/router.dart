import 'package:go_router/go_router.dart';

import '../presentation/screens/home_screen.dart';
import '../presentation/screens/licences_screen.dart';
import '../presentation/screens/round/round_host_screen.dart';
import '../presentation/screens/round_setup_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/standings_screen.dart';
import '../presentation/screens/trip_setup_screen.dart';
import '../presentation/screens/wrapped_screen.dart';

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
        GoRoute(path: Routes.home, builder: (c, s) => const HomeScreen()),
        GoRoute(path: Routes.newTrip, builder: (c, s) => const TripSetupScreen()),
        GoRoute(path: '/trip/:tripId/edit', builder: (c, s) => TripSetupScreen(tripId: _id(s, 'tripId'))),
        GoRoute(path: '/trip/:tripId/round/new', builder: (c, s) => RoundSetupScreen(tripId: _id(s, 'tripId'))),
        GoRoute(path: '/round/:roundId', builder: (c, s) => RoundHostScreen(roundId: _id(s, 'roundId'))),
        GoRoute(path: '/trip/:tripId/standings', builder: (c, s) => StandingsScreen(tripId: _id(s, 'tripId'))),
        GoRoute(path: '/trip/:tripId/wrapped', builder: (c, s) => WrappedScreen(tripId: _id(s, 'tripId'))),
        GoRoute(path: Routes.settings, builder: (c, s) => const SettingsScreen()),
        GoRoute(path: Routes.licences, builder: (c, s) => const LicencesScreen()),
      ],
    );

