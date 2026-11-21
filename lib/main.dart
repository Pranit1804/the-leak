import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/router.dart';
import 'application/providers.dart';
import 'application/round_controller.dart';
import 'data/db/app_database.dart';
import 'presentation/screens/licences_screen.dart';
import 'services/announcer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerFontLicences();
  final db = AppDatabase();
  final prefs = await SharedPreferences.getInstance();

  // On launch, if any round is not done, open it directly (TECH_SPEC section 7).
  final open = await db.roundDao.openRound();
  final router = buildRouter(initialLocation: open == null ? Routes.home : Routes.round(open.id));

  runApp(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(db),
      sharedPreferencesProvider.overrideWithValue(prefs),
      roundEventsProvider.overrideWith(AnnouncerEvents.new),
    ],
    child: TheLeakApp(router: router),
  ));
}
