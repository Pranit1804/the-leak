import '../../../domain/models/role.dart';

/// Role card copy. Players see the Insider as "The Leak".
class RoleCopy {
  const RoleCopy({required this.title, required this.job, required this.scoring, required this.scoringLead});

  final String title;
  final String job;

  /// Bold lead of the scoring line ("+3").
  final String scoringLead;
  final String scoring;

  static RoleCopy of(Role role, {required bool carMode}) {
    final group = carMode ? 'car' : 'group';
    return switch (role) {
      Role.insider => RoleCopy(
          title: 'THE LEAK',
          job: 'You know the word. Ask questions like everyone else and steer the $group to it without getting caught.',
          scoringLead: '+3',
          scoring: ' if the word is found and nobody catches you. No word, no points for anyone.',
        ),
      Role.master => const RoleCopy(
          title: 'THE MASTER',
          job: "You know the word. Answer every question out loud with yes, no or doesn't matter, and tap +1 for each one.",
          scoringLead: '+1',
          scoring: ' if the word is found and the leak is caught. Everyone knows you are the Master.',
        ),
      Role.common => RoleCopy(
          title: 'COMMON',
          job: 'You do not know the word. Ask yes or no questions with the $group to crack it, then find the leak.',
          scoringLead: '+2',
          scoring: ' each if the word is found and the leak is caught. No word, no points for anyone.',
        ),
    };
  }
}
