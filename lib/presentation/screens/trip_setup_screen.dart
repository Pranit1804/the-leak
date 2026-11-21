import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/tokens.dart';
import '../../application/providers.dart';
import '../../application/trip_controller.dart';
import '../../data/repositories/trip_repository.dart';
import '../../domain/engine/role_assigner.dart';
import '../format.dart';
import '../widgets/ink_button.dart';
import '../widgets/screen_scaffold.dart';
import '../widgets/section_header.dart';
import '../widgets/square_field.dart';

const maxNameLength = 16;

/// Problems with the player list, or null when it can be saved.
String? playerListProblem(List<PlayerDraft> players) {
  if (players.length < minPlayers) {
    final need = minPlayers - players.length;
    return 'Add ${need == 1 ? 'one more player' : '$need more players'}. The Leak needs $minPlayers to $maxPlayers.';
  }
  if (players.length > maxPlayers) return 'Up to $maxPlayers players can play.';
  final seen = <String>{};
  for (final p in players) {
    if (!seen.add(p.name.trim().toLowerCase())) return 'Two players are called ${p.name}. Names must be different.';
  }
  return null;
}

/// Why a name can't be added, or null when it can.
String? addNameProblem(String name, List<PlayerDraft> players) {
  final n = name.trim();
  if (n.isEmpty) return 'Type a name first.';
  if (players.length >= maxPlayers) return 'Up to $maxPlayers players can play.';
  if (players.any((p) => p.name.trim().toLowerCase() == n.toLowerCase())) return '$n is already in the trip.';
  return null;
}

/// Trip setup (02). With [tripId] it edits the players of an existing trip between rounds.
class TripSetupScreen extends ConsumerStatefulWidget {
  const TripSetupScreen({super.key, this.tripId});

  final int? tripId;

  @override
  ConsumerState<TripSetupScreen> createState() => _TripSetupScreenState();
}

class _TripSetupScreenState extends ConsumerState<TripSetupScreen> {
  final _name = TextEditingController();
  final _add = TextEditingController();
  final _addFocus = FocusNode();
  List<PlayerDraft> _players = [];
  String? _addError;
  bool _loaded = false;
  bool _saving = false;

  bool get _editing => widget.tripId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_editing) {
      final trips = ref.read(tripRepositoryProvider);
      final trip = await trips.getTrip(widget.tripId!);
      final players = await trips.players(widget.tripId!);
      _name.text = trip?.name ?? '';
      _players = [for (final p in players.where((p) => p.active)) PlayerDraft(id: p.id, name: p.name, canDrive: p.canDrive)];
    } else {
      _name.text = defaultTripName(ref.read(clockProvider)());
    }
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _name.dispose();
    _add.dispose();
    _addFocus.dispose();
    super.dispose();
  }

  void _addPlayer() {
    final problem = addNameProblem(_add.text, _players);
    setState(() {
      _addError = problem;
      if (problem == null) {
        _players = [..._players, PlayerDraft(name: _add.text.trim(), canDrive: false)];
        _add.clear();
      }
    });
    _addFocus.requestFocus();
  }

  Future<void> _save() async {
    if (_saving || playerListProblem(_players) != null) return;
    setState(() => _saving = true);
    final name = _name.text.trim().isEmpty ? defaultTripName(ref.read(clockProvider)()) : _name.text.trim();
    final trips = ref.read(tripControllerProvider);
    if (_editing) {
      await trips.updateTrip(widget.tripId!, name: name, players: _players);
      if (!mounted) return;
      context.go(Routes.newRound(widget.tripId!));
    } else {
      final id = await trips.createTrip(name: name, players: _players);
      if (!mounted) return;
      context.go(Routes.newRound(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(backgroundColor: AppColors.paper);
    final problem = playerListProblem(_players);
    final note = _addError ?? (_players.isNotEmpty ? problem : null);
    return PaperScreen(
      body: [
        BackHeader(
          label: 'The Leak',
          onBack: () => _editing ? context.go(Routes.newRound(widget.tripId!)) : (context.canPop() ? context.pop() : context.go(Routes.home)),
        ),
        Headline(_editing ? 'Edit players' : 'New trip'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('TRIP NAME', style: AppText.label()),
            const SizedBox(height: 6),
            SquareTextField(controller: _name, maxLength: 40, semanticLabel: 'Trip name', textInputAction: TextInputAction.next),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 6),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ink, width: AppSpace.heavyRule))),
              child: Row(children: [
                Expanded(child: Text('PLAYERS (${_players.length}) · IN SEAT ORDER', style: AppText.label())),
                Text('DRIVES', style: AppText.label()),
              ]),
            ),
            _playerList(),
          ],
        ),
        Row(children: [
          Expanded(
            child: SquareTextField(
              controller: _add,
              focusNode: _addFocus,
              hint: 'Add a player',
              dashed: true,
              fontSize: 16,
              weight: 500,
              maxLength: maxNameLength,
              semanticLabel: 'Add player',
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addPlayer(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 76, child: OutlineInkButton(label: 'Add', height: 50, fontSize: 13, onPressed: _addPlayer)),
        ]),
        if (note != null) NoteLine(label: 'Note', text: note, inline: true),
        Text(
          _players.isEmpty
              ? 'Add everyone in the order you sit. Tick who can drive to use Car mode.'
              : 'Hold and drag a name to change the seat order. Swipe a name to remove it.',
          style: AppText.ui(13, color: AppColors.inkMuted),
        ),
      ],
      bottom: [
        InkButton(label: _editing ? 'Save players' : 'Save and continue', onPressed: problem == null && !_saving ? _save : null),
      ],
    );
  }

  Widget _playerList() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: _players.length,
      proxyDecorator: (child, index, animation) => Material(
        color: AppColors.paperRaised,
        elevation: 0,
        shape: const RoundedRectangleBorder(side: BorderSide(color: AppColors.ink, width: AppSpace.control)),
        child: child,
      ),
      onReorderItem: (from, to) => setState(() {
        final list = [..._players];
        final p = list.removeAt(from);
        list.insert(to, p);
        _players = list;
      }),
      itemBuilder: (context, i) {
        final p = _players[i];
        final key = ValueKey(p.id ?? 'new-${p.name}');
        return Dismissible(
          key: key,
          direction: DismissDirection.horizontal,
          background: Container(
            color: AppColors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('REMOVE', style: AppText.label(color: AppColors.onInk)),
          ),
          secondaryBackground: Container(
            color: AppColors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text('REMOVE', style: AppText.label(color: AppColors.onInk)),
          ),
          onDismissed: (_) => setState(() {
            _players = [..._players]..removeAt(i);
            _addError = null;
          }),
          child: ReorderableDelayedDragStartListener(
            index: i,
            child: Container(
              height: 50,
              color: AppColors.paper,
              child: Container(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.ruleLight, width: AppSpace.lightRule))),
                child: Row(children: [
                  SizedBox(width: 20, child: Text('${i + 1}', style: AppText.display(18, color: AppColors.inkFaint))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(p.name, style: AppText.ui(17, weight: 600), overflow: TextOverflow.ellipsis)),
                  SquareCheckbox(
                    value: p.canDrive,
                    semanticLabel: '${p.name} can drive',
                    onChanged: (v) => setState(() => _players = [..._players]..[i] = p.copyWith(canDrive: v)),
                  ),
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
