import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/tokens.dart';
import '../widgets/screen_scaffold.dart';
import '../widgets/section_header.dart';

/// The bundled fonts' SIL Open Font License texts, by family.
const fontLicenceAssets = {
  'Anton': 'assets/fonts/Anton-OFL.txt',
  'Libre Franklin': 'assets/fonts/LibreFranklin-OFL.txt',
  'Libre Caslon Text': 'assets/fonts/LibreCaslonText-OFL.txt',
};

/// Adds the font licences to Flutter's LicenseRegistry (called from main).
void registerFontLicences() {
  LicenseRegistry.addLicense(() async* {
    for (final e in fontLicenceAssets.entries) {
      yield LicenseEntryWithLineBreaks(['${e.key} (font)'], await rootBundle.loadString(e.value));
    }
  });
}

class _Group {
  _Group(this.name);
  final String name;
  final List<String> texts = [];
}

/// Licences: the font OFL texts first, then every package licence.
class LicencesScreen extends StatefulWidget {
  const LicencesScreen({super.key});

  @override
  State<LicencesScreen> createState() => _LicencesScreenState();
}

class _LicencesScreenState extends State<LicencesScreen> {
  late final Future<List<_Group>> _groups = _load();

  Future<List<_Group>> _load() async {
    final byName = <String, _Group>{};
    await for (final entry in LicenseRegistry.licenses) {
      final text = entry.paragraphs.map((p) => p.text).join('\n\n');
      for (final pkg in entry.packages) {
        (byName[pkg] ??= _Group(pkg)).texts.add(text);
      }
    }
    final list = byName.values.toList()
      ..sort((a, b) {
        final fa = a.name.endsWith('(font)'), fb = b.name.endsWith('(font)');
        if (fa != fb) return fa ? -1 : 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_Group>>(
      future: _groups,
      builder: (context, snap) {
        final groups = snap.data ?? const <_Group>[];
        final media = MediaQuery.of(context);
        return Scaffold(
          backgroundColor: AppColors.paper,
          body: ListView.builder(
            padding: EdgeInsets.fromLTRB(AppSpace.screenX, (media.viewPadding.top + 12).clamp(AppSpace.screenTop, 100), AppSpace.screenX,
                AppSpace.screenBottom + media.viewPadding.bottom),
            itemCount: groups.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  BackHeader(label: 'The Leak', onBack: () => context.canPop() ? context.pop() : context.go(Routes.settings)),
                  const SizedBox(height: 16),
                  const Headline('Licences'),
                  const SizedBox(height: 6),
                  Text('Fonts are bundled under the SIL Open Font License 1.1.', style: AppText.voice(17)),
                  const SizedBox(height: 16),
                  if (snap.connectionState != ConnectionState.done) Text('Loading…', style: AppText.ui(14, color: AppColors.inkMuted)),
                ]);
              }
              final g = groups[i - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Rule.heavy(),
                  const SizedBox(height: 8),
                  SectionHeader(left: g.name),
                  const SizedBox(height: 8),
                  for (final t in g.texts) ...[
                    Text(t, style: AppText.ui(12, color: AppColors.inkMuted, height: 1.4)),
                    const SizedBox(height: 10),
                  ],
                ]),
              );
            },
          ),
        );
      },
    );
  }
}
